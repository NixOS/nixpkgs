# This file originates from node2nix

{
  lib,
  stdenv,
  nodejs,
  python2,
  pkgs,
  libtool,
  runCommand,
  writeTextFile,
  writeShellScript,
}:

let
  # Workaround to cope with utillinux in Nixpkgs 20.09 and util-linux in Nixpkgs master
  utillinux = if pkgs ? utillinux then pkgs.utillinux else pkgs.util-linux;

  python = if nodejs ? python then nodejs.python else python2;

  # Create a tar wrapper that filters all the 'Ignoring unknown extended header keyword' noise
  tarWrapper = runCommand "tarWrapper" { } ''
    mkdir -p $out/bin

    cat > $out/bin/tar <<EOF
    #! ${stdenv.shell} -e
    $(type -p tar) "\$@" --warning=no-unknown-keyword --delay-directory-restore
    EOF

    chmod +x $out/bin/tar
  '';

  # Function that generates a TGZ file from a NPM project
  buildNodeSourceDist =
    {
      name,
      version,
      src,
      ...
    }:

    stdenv.mkDerivation {
      name = "node-tarball-${name}-${version}";
      inherit src;
      buildInputs = [ nodejs ];
      buildPhase = ''
        export HOME=$TMPDIR
        tgzFile=$(npm pack | tail -n 1) # Hooks to the pack command will add output (https://docs.npmjs.com/misc/scripts)
      '';
      installPhase = ''
        mkdir -p $out/tarballs
        mv $tgzFile $out/tarballs
        mkdir -p $out/nix-support
        echo "file source-dist $out/tarballs/$tgzFile" >> $out/nix-support/hydra-build-products
      '';
    };

  # Common shell logic
  installPackage = writeShellScript "install-package" ''
    installPackage() {
      local packageName=$1 src=$2

      local strippedName

      local DIR=$PWD
      cd $TMPDIR

      unpackFile $src

      # Make the base dir in which the target dependency resides first
      mkdir -p "$(dirname "$DIR/$packageName")"

      if [ -f "$src" ]
      then
          # Figure out what directory has been unpacked
          packageDir="$(find . -maxdepth 1 -type d | tail -1)"

          # Restore write permissions to make building work
          find "$packageDir" -type d -exec chmod u+x {} \;
          chmod -R u+w "$packageDir"

          # Move the extracted tarball into the output folder
          mv "$packageDir" "$DIR/$packageName"
      elif [ -d "$src" ]
      then
          # Get a stripped name (without hash) of the source directory.
          # On old nixpkgs it's already set internally.
          if [ -z "$strippedName" ]
          then
              strippedName="$(stripHash $src)"
          fi

          # Restore write permissions to make building work
          chmod -R u+w "$strippedName"

          # Move the extracted directory into the output folder
          mv "$strippedName" "$DIR/$packageName"
      fi

      # Change to the package directory to install dependencies
      cd "$DIR/$packageName"
    }
  '';

  # Bundle the dependencies of the package
  #
  # Only include dependencies if they don't exist. They may also be bundled in the package.
  includeDependencies =
    { dependencies }:
    lib.optionalString (dependencies != [ ]) (
      ''
        mkdir -p node_modules
        cd node_modules
      ''
      + (lib.concatMapStrings (dependency: ''
        if [ ! -e "${dependency.packageName}" ]; then
            ${composePackage dependency}
        fi
      '') dependencies)
      + ''
        cd ..
      ''
    );

  # Recursively composes the dependencies of a package
  composePackage =
    {
      name,
      packageName,
      src,
      dependencies ? [ ],
      ...
    }@args:
    builtins.addErrorContext "while evaluating node package '${packageName}'" ''
      installPackage "${packageName}" "${src}"
      ${includeDependencies { inherit dependencies; }}
      cd ..
      ${lib.optionalString (builtins.substring 0 1 packageName == "@") "cd .."}
    '';

  pinpointDependencies =
    { dependencies, production }:
    let
      pinpointDependenciesFromPackageJSON = writeTextFile {
        name = "pinpointDependencies.js";
        text = ''
          var fs = require('fs');
          var path = require('path');

          function resolveDependencyVersion(location, name) {
              if(location == process.env['NIX_STORE']) {
                  return null;
              } else {
                  var dependencyPackageJSON = path.join(location, "node_modules", name, "package.json");

                  if(fs.existsSync(dependencyPackageJSON)) {
                      var dependencyPackageObj = JSON.parse(fs.readFileSync(dependencyPackageJSON));

                      if(dependencyPackageObj.name == name) {
                          return dependencyPackageObj.version;
                      }
                  } else {
                      return resolveDependencyVersion(path.resolve(location, ".."), name);
                  }
              }
          }

          function replaceDependencies(dependencies) {
              if(typeof dependencies == "object" && dependencies !== null) {
                  for(var dependency in dependencies) {
                      var resolvedVersion = resolveDependencyVersion(process.cwd(), dependency);

                      if(resolvedVersion === null) {
                          process.stderr.write("WARNING: cannot pinpoint dependency: "+dependency+", context: "+process.cwd()+"\n");
                      } else {
                          dependencies[dependency] = resolvedVersion;
                      }
                  }
              }
          }

          /* Read the package.json configuration */
          var packageObj = JSON.parse(fs.readFileSync('./package.json'));

          /* Pinpoint all dependencies */
          replaceDependencies(packageObj.dependencies);
          if(process.argv[2] == "development") {
              replaceDependencies(packageObj.devDependencies);
          }
          else {
              packageObj.devDependencies = {};
          }
          replaceDependencies(packageObj.optionalDependencies);
          replaceDependencies(packageObj.peerDependencies);

          /* Write the fixed package.json file */
          fs.writeFileSync("package.json", JSON.stringify(packageObj, null, 2));
        '';
      };
    in
    ''
      node ${pinpointDependenciesFromPackageJSON} ${if production then "production" else "development"}

      ${lib.optionalString (dependencies != [ ]) ''
        if [ -d node_modules ]
        then
            cd node_modules
            ${lib.concatMapStrings (dependency: pinpointDependenciesOfPackage dependency) dependencies}
            cd ..
        fi
      ''}
    '';

  # Recursively traverses all dependencies of a package and pinpoints all
  # dependencies in the package.json file to the versions that are actually
  # being used.

  pinpointDependenciesOfPackage =
    {
      packageName,
      dependencies ? [ ],
      production ? true,
      ...
    }@args:
    ''
      if [ -d "${packageName}" ]
      then
          cd "${packageName}"
          ${pinpointDependencies { inherit dependencies production; }}
          cd ..
          ${lib.optionalString (builtins.substring 0 1 packageName == "@") "cd .."}
      fi
    '';

  # Extract the Node.js source code which is used to compile packages with
  # native bindings
  nodeSources = runCommand "node-sources" { } ''
    tar --no-same-owner --no-same-permissions -xf ${nodejs.src}
    mv node-* $out
  '';

  # Script that adds _integrity fields to all package.json files to prevent NPM from consulting the cache (that is empty)
  addIntegrityFieldsScript = writeTextFile {
    name = "addintegrityfields.js";
    text = ''
      var fs = require('fs');
      var path = require('path');

      function augmentDependencies(baseDir, dependencies) {
          for(var dependencyName in dependencies) {
              var dependency = dependencies[dependencyName];

              // Open package.json and augment metadata fields
              var packageJSONDir = path.join(baseDir, "node_modules", dependencyName);
              var packageJSONPath = path.join(packageJSONDir, "package.json");

              if(fs.existsSync(packageJSONPath)) { // Only augment packages that exist. Sometimes we may have production installs in which development dependencies can be ignored
                  console.log("Adding metadata fields to: "+packageJSONPath);
                  var packageObj = JSON.parse(fs.readFileSync(packageJSONPath));

                  if(dependency.integrity) {
                      packageObj["_integrity"] = dependency.integrity;
                  } else {
                      packageObj["_integrity"] = "sha1-000000000000000000000000000="; // When no _integrity string has been provided (e.g. by Git dependencies), add a dummy one. It does not seem to harm and it bypasses downloads.
                  }

                  if(dependency.resolved) {
                      packageObj["_resolved"] = dependency.resolved; // Adopt the resolved property if one has been provided
                  } else {
                      packageObj["_resolved"] = dependency.version; // Set the resolved version to the version identifier. This prevents NPM from cloning Git repositories.
                  }

                  if(dependency.from !== undefined) { // Adopt from property if one has been provided
                      packageObj["_from"] = dependency.from;
                  }

                  fs.writeFileSync(packageJSONPath, JSON.stringify(packageObj, null, 2));
              }

              // Augment transitive dependencies
              if(dependency.dependencies !== undefined) {
                  augmentDependencies(packageJSONDir, dependency.dependencies);
              }
          }
      }

      if(fs.existsSync("./package-lock.json")) {
          var packageLock = JSON.parse(fs.readFileSync("./package-lock.json"));

          if(![1, 2].includes(packageLock.lockfileVersion)) {
            process.stderr.write("Sorry, I only understand lock file versions 1 and 2!\n");
            process.exit(1);
          }

          if(packageLock.dependencies !== undefined) {
              augmentDependencies(".", packageLock.dependencies);
          }
      }
    '';
  };

  # Reconstructs a package-lock file from the node_modules/ folder structure and package.json files with dummy sha1 hashes
  reconstructPackageLock = writeTextFile {
    name = "reconstructpackagelock.js";
    text = ''
      var fs = require('fs');
      var path = require('path');

      var packageObj = JSON.parse(fs.readFileSync("package.json"));

      var lockObj = {
          name: packageObj.name,
          version: packageObj.version,
          lockfileVersion: 2,
          requires: true,
          packages: {
              "": {
                  name: packageObj.name,
                  version: packageObj.version,
                  license: packageObj.license,
                  bin: packageObj.bin,
                  dependencies: packageObj.dependencies,
                  engines: packageObj.engines,
                  optionalDependencies: packageObj.optionalDependencies
              }
          },
          dependencies: {}
      };

      function augmentPackageJSON(filePath, packages, dependencies) {
          var packageJSON = path.join(filePath, "package.json");
          if(fs.existsSync(packageJSON)) {
              var packageObj = JSON.parse(fs.readFileSync(packageJSON));
              packages[filePath] = {
                  version: packageObj.version,
                  integrity: "sha1-000000000000000000000000000=",
                  dependencies: packageObj.dependencies,
                  engines: packageObj.engines,
                  optionalDependencies: packageObj.optionalDependencies
              };
              dependencies[packageObj.name] = {
                  version: packageObj.version,
                  integrity: "sha1-000000000000000000000000000=",
                  dependencies: {}
              };
              processDependencies(path.join(filePath, "node_modules"), packages, dependencies[packageObj.name].dependencies);
          }
      }

      function processDependencies(dir, packages, dependencies) {
          if(fs.existsSync(dir)) {
              var files = fs.readdirSync(dir);

              files.forEach(function(entry) {
                  var filePath = path.join(dir, entry);
                  var stats = fs.statSync(filePath);

                  if(stats.isDirectory()) {
                      if(entry.substr(0, 1) == "@") {
                          // When we encounter a namespace folder, augment all packages belonging to the scope
                          var pkgFiles = fs.readdirSync(filePath);

                          pkgFiles.forEach(function(entry) {
                              if(stats.isDirectory()) {
                                  var pkgFilePath = path.join(filePath, entry);
                                  augmentPackageJSON(pkgFilePath, packages, dependencies);
                              }
                          });
                      } else {
                          augmentPackageJSON(filePath, packages, dependencies);
                      }
                  }
              });
          }
      }

      processDependencies("node_modules", lockObj.packages, lockObj.dependencies);

      fs.writeFileSync("package-lock.json", JSON.stringify(lockObj, null, 2));
    '';
  };

  # Script that links bins defined in package.json to the node_modules bin directory
  # NPM does not do this for top-level packages itself anymore as of v7
  linkBinsScript = writeTextFile {
    name = "linkbins.js";
    text = ''
      var fs = require('fs');
      var path = require('path');

      var packageObj = JSON.parse(fs.readFileSync("package.json"));

      var nodeModules = Array(packageObj.name.split("/").length).fill("..").join(path.sep);

      if(packageObj.bin !== undefined) {
          fs.mkdirSync(path.join(nodeModules, ".bin"))

          if(typeof packageObj.bin == "object") {
              Object.keys(packageObj.bin).forEach(function(exe) {
                  if(fs.existsSync(packageObj.bin[exe])) {
                      console.log("linking bin '" + exe + "'");
                      fs.symlinkSync(
                          path.join("..", packageObj.name, packageObj.bin[exe]),
                          path.join(nodeModules, ".bin", exe)
                      );
                  }
                  else {
                      console.log("skipping non-existent bin '" + exe + "'");
                  }
              })
          }
          else {
              if(fs.existsSync(packageObj.bin)) {
                  console.log("linking bin '" + packageObj.bin + "'");
                  fs.symlinkSync(
                      path.join("..", packageObj.name, packageObj.bin),
                      path.join(nodeModules, ".bin", packageObj.name.split("/").pop())
                  );
              }
              else {
                  console.log("skipping non-existent bin '" + packageObj.bin + "'");
              }
          }
      }
      else if(packageObj.directories !== undefined && packageObj.directories.bin !== undefined) {
          fs.mkdirSync(path.join(nodeModules, ".bin"))

          fs.readdirSync(packageObj.directories.bin).forEach(function(exe) {
              if(fs.existsSync(path.join(packageObj.directories.bin, exe))) {
                  console.log("linking bin '" + exe + "'");
                  fs.symlinkSync(
                      path.join("..", packageObj.name, packageObj.directories.bin, exe),
                      path.join(nodeModules, ".bin", exe)
                  );
              }
              else {
                  console.log("skipping non-existent bin '" + exe + "'");
              }
          })
      }
    '';
  };

  prepareAndInvokeNPM =
    {
      packageName,
      bypassCache,
      reconstructLock,
      npmFlags,
      production,
    }:
    let
      forceOfflineFlag = if bypassCache then "--offline" else "--registry http://www.example.com";
    in
    ''
      # Pinpoint the versions of all dependencies to the ones that are actually being used
      echo "pinpointing versions of dependencies..."
      source $pinpointDependenciesScriptPath

      # Patch the shebangs of the bundled modules to prevent them from
      # calling executables outside the Nix store as much as possible
      patchShebangs .

      # Deploy the Node.js package by running npm install. Since the
      # dependencies have been provided already by ourselves, it should not
      # attempt to install them again, which is good, because we want to make
      # it Nix's responsibility. If it needs to install any dependencies
      # anyway (e.g. because the dependency parameters are
      # incomplete/incorrect), it fails.
      #
      # The other responsibilities of NPM are kept -- version checks, build
      # steps, postprocessing etc.

      export HOME=$TMPDIR
      cd "${packageName}"
      runHook preRebuild

      ${lib.optionalString bypassCache ''
        ${lib.optionalString reconstructLock ''
          if [ -f package-lock.json ]
          then
              echo "WARNING: Reconstruct lock option enabled, but a lock file already exists!"
              echo "This will most likely result in version mismatches! We will remove the lock file and regenerate it!"
              rm package-lock.json
          else
              echo "No package-lock.json file found, reconstructing..."
          fi

          node ${reconstructPackageLock}
        ''}

        node ${addIntegrityFieldsScript}
      ''}

      npm ${forceOfflineFlag} --nodedir=${nodeSources} ${npmFlags} ${lib.optionalString production "--production"} rebuild

      runHook postRebuild

      if [ "''${dontNpmInstall-}" != "1" ]
      then
          # NPM tries to download packages even when they already exist if npm-shrinkwrap is used.
          rm -f npm-shrinkwrap.json

          npm ${forceOfflineFlag} --nodedir=${nodeSources} --no-bin-links --ignore-scripts ${npmFlags} ${lib.optionalString production "--production"} install
      fi

      # Link executables defined in package.json
      node ${linkBinsScript}
    '';

  # Builds and composes an NPM package including all its dependencies
  buildNodePackage =
    {
      name,
      packageName,
      version ? null,
      dependencies ? [ ],
      buildInputs ? [ ],
      production ? true,
      npmFlags ? "",
      dontNpmInstall ? false,
      bypassCache ? false,
      reconstructLock ? false,
      preRebuild ? "",
      dontStrip ? true,
      unpackPhase ? "true",
      buildPhase ? "true",
      meta ? { },
      ...
    }@args:

    let
      extraArgs = removeAttrs args [
        "name"
        "dependencies"
        "buildInputs"
        "dontStrip"
        "dontNpmInstall"
        "preRebuild"
        "unpackPhase"
        "buildPhase"
        "meta"
      ];
    in
    stdenv.mkDerivation (
      {
        name = "${name}${if version == null then "" else "-${version}"}";
        buildInputs =
          [
            tarWrapper
            python
            nodejs
          ]
          ++ lib.optional (stdenv.isLinux) utillinux
          ++ lib.optional (stdenv.isDarwin) libtool
          ++ buildInputs;

        inherit nodejs;

        inherit dontStrip; # Stripping may fail a build for some package deployments
        inherit
          dontNpmInstall
          preRebuild
          unpackPhase
          buildPhase
          ;

        compositionScript = composePackage args;
        pinpointDependenciesScript = pinpointDependenciesOfPackage args;

        passAsFile = [
          "compositionScript"
          "pinpointDependenciesScript"
        ];

        installPhase = ''
          source ${installPackage}

          # Create and enter a root node_modules/ folder
          mkdir -p $out/lib/node_modules
          cd $out/lib/node_modules

          # Compose the package and all its dependencies
          source $compositionScriptPath

          ${prepareAndInvokeNPM {
            inherit
              packageName
              bypassCache
              reconstructLock
              npmFlags
              production
              ;
          }}

          # Create symlink to the deployed executable folder, if applicable
          if [ -d "$out/lib/node_modules/.bin" ]
          then
              ln -s $out/lib/node_modules/.bin $out/bin

              # Fixup all executables
              ls $out/bin/* | while read i
              do
                  file="$(readlink -f "$i")"
                  chmod u+rwx "$file"
                  if isScript "$file"
                  then
                      sed -i 's/\r$//' "$file"  # convert crlf to lf
                  fi
              done
          fi

          # Create symlinks to the deployed manual page folders, if applicable
          if [ -d "$out/lib/node_modules/${packageName}/man" ]
          then
              mkdir -p $out/share
              for dir in "$out/lib/node_modules/${packageName}/man/"*
              do
                  mkdir -p $out/share/man/$(basename "$dir")
                  for page in "$dir"/*
                  do
                      ln -s $page $out/share/man/$(basename "$dir")
                  done
              done
          fi

          # Run post install hook, if provided
          runHook postInstall
        '';

        meta = {
          # default to Node.js' platforms
          platforms = nodejs.meta.platforms;
        } // meta;
      }
      // extraArgs
    );

  # Builds a node environment (a node_modules folder and a set of binaries)
  buildNodeDependencies =
    {
      name,
      packageName,
      version ? null,
      src,
      dependencies ? [ ],
      buildInputs ? [ ],
      production ? true,
      npmFlags ? "",
      dontNpmInstall ? false,
      bypassCache ? false,
      reconstructLock ? false,
      dontStrip ? true,
      unpackPhase ? "true",
      buildPhase ? "true",
      ...
    }@args:

    let
      extraArgs = removeAttrs args [
        "name"
        "dependencies"
        "buildInputs"
      ];
    in
    stdenv.mkDerivation (
      {
        name = "node-dependencies-${name}${if version == null then "" else "-${version}"}";

        buildInputs =
          [
            tarWrapper
            python
            nodejs
          ]
          ++ lib.optional (stdenv.isLinux) utillinux
          ++ lib.optional (stdenv.isDarwin) libtool
          ++ buildInputs;

        inherit dontStrip; # Stripping may fail a build for some package deployments
        inherit dontNpmInstall unpackPhase buildPhase;

        includeScript = includeDependencies { inherit dependencies; };
        pinpointDependenciesScript = pinpointDependenciesOfPackage args;

        passAsFile = [
          "includeScript"
          "pinpointDependenciesScript"
        ];

        installPhase = ''
          source ${installPackage}

          mkdir -p $out/${packageName}
          cd $out/${packageName}

          source $includeScriptPath

          # Create fake package.json to make the npm commands work properly
          cp ${src}/package.json .
          chmod 644 package.json
          ${lib.optionalString bypassCache ''
            if [ -f ${src}/package-lock.json ]
            then
                cp ${src}/package-lock.json .
                chmod 644 package-lock.json
            fi
          ''}

          # Go to the parent folder to make sure that all packages are pinpointed
          cd ..
          ${lib.optionalString (builtins.substring 0 1 packageName == "@") "cd .."}

          ${prepareAndInvokeNPM {
            inherit
              packageName
              bypassCache
              reconstructLock
              npmFlags
              production
              ;
          }}

          # Expose the executables that were installed
          cd ..
          ${lib.optionalString (builtins.substring 0 1 packageName == "@") "cd .."}

          mv ${packageName} lib
          ln -s $out/lib/node_modules/.bin $out/bin
        '';
      }
      // extraArgs
    );

  # Builds a development shell
  buildNodeShell =
    {
      name,
      packageName,
      version ? null,
      src,
      dependencies ? [ ],
      buildInputs ? [ ],
      production ? true,
      npmFlags ? "",
      dontNpmInstall ? false,
      bypassCache ? false,
      reconstructLock ? false,
      dontStrip ? true,
      unpackPhase ? "true",
      buildPhase ? "true",
      ...
    }@args:

    let
      nodeDependencies = buildNodeDependencies args;
      extraArgs = removeAttrs args [
        "name"
        "dependencies"
        "buildInputs"
        "dontStrip"
        "dontNpmInstall"
        "unpackPhase"
        "buildPhase"
      ];
    in
    stdenv.mkDerivation (
      {
        name = "node-shell-${name}${if version == null then "" else "-${version}"}";

        buildInputs =
          [
            python
            nodejs
          ]
          ++ lib.optional (stdenv.isLinux) utillinux
          ++ buildInputs;
        buildCommand = ''
          mkdir -p $out/bin
          cat > $out/bin/shell <<EOF
          #! ${stdenv.shell} -e
          $shellHook
          exec ${stdenv.shell}
          EOF
          chmod +x $out/bin/shell
        '';

        # Provide the dependencies in a development shell through the NODE_PATH environment variable
        inherit nodeDependencies;
        shellHook = lib.optionalString (dependencies != [ ]) ''
          export NODE_PATH=${nodeDependencies}/lib/node_modules
          export PATH="${nodeDependencies}/bin:$PATH"
        '';
      }
      // extraArgs
    );
in
{
  buildNodeSourceDist = lib.makeOverridable buildNodeSourceDist;
  buildNodePackage = lib.makeOverridable buildNodePackage;
  buildNodeDependencies = lib.makeOverridable buildNodeDependencies;
  buildNodeShell = lib.makeOverridable buildNodeShell;
}
