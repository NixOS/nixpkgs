{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nwjs,
  makeWrapper,
  python3,
  fetchurl,
}:

let
  # Use unstable because it has improvements for finding python
  version = "0-unstable-2024-07-11";

  src = fetchFromGitHub {
    owner = "FPGAwars";
    repo = "icestudio";
    rev = "5df95bfbcc9540675897256e0a372f8039b534c5";
    hash = "sha256-0HETAeR8OCsu7caP8SbBVYSLQIxMKjV1flR24MizSnU=";
  };

  collection = fetchurl {
    url = "https://github.com/FPGAwars/collection-default/archive/v0.4.1.zip";
    hash = "sha256-F2cAqkTPC7xfGnPQiS8lTrD4y34EkHFUEDPVaYzVVg8=";
  };

  app = buildNpmPackage {
    pname = "icestudio-app";
    inherit version src;
    sourceRoot = "${src.name}/app";
    npmDepsHash = "sha256-gfkLW8OaCpaq5KHBhttqMTQPfhUCs22ii6UvNxqWnsQ=";
    dontNpmBuild = true;
    installPhase = ''
      cp -r . $out
    '';
  };
in
buildNpmPackage rec {
  inherit version src;
  pname = "icestudio";
  npmDepsHash = "sha256-K90zgKHqNEvjjM20YaXa24J0dGA2MESNvzvsr31AR2Y=";
  npmFlags = [
    # Use the legacy dependency resolution, with less strict version
    # requirements for transative dependencies
    "--legacy-peer-deps"

    # We want to avoid call the scripts/postInstall.sh until we copy the
    # collection and app derivation we do that on installPhase
    "--ignore-scripts"
  ];

  buildPhase = ''
    # step 1: Copy the `app` derivation into the folder expected for grunt
    cp -r ${app}/* app

    # step 2: Copy the cached `collection` derivation into the cache location
    # so that grunt avoids downloading it
    install -m444 -D ${collection} cache/collection/collection-default.zip

    ./node_modules/.bin/grunt getcollection

    # step 3: use grunt to distribute package
    # TODO: support aarch64
    ./node_modules/.bin/grunt dist \
        --platform=none    `# skip platform-specific steps` \
        --dont-build-nwjs  `# use the nwjs package shipped by Nix` \
        --dont-clean-tmp   `# skip cleaning the tmp folder as we'll use it in $out`
  '';

  installPhase = ''
    cp -r dist/tmp $out
    mkdir -p $out/share/applications
    cp res/AppImage/icestudio.AppDir/Icestudio.desktop $out/share/applications/
    substituteInPlace $out/share/applications/Icestudio.desktop \
      --replace-fail "/usr/bin/icestudio" "$out/bin/icestudio"
    makeWrapper ${nwjs}/bin/nw $out/bin/${pname} \
        --add-flags $out \
        --prefix PATH : "${python3}/bin"

  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ python3 ];

  meta = {
    description = "Visual editor for open FPGA boards";
    homepage = "https://github.com/FPGAwars/icestudio/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      kiike
      jleightcap
      rcoeurjoly
      amerino
    ];
    mainProgram = "icestudio";
    platforms = lib.platforms.linux;
  };
}
