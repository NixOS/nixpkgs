{
  lib,
  stdenv,
  fetchurl,
  gnutar,
  gzip,
  perl,
  curl,
  which,
  makeWrapper,
  runCommand,
}:
let
  version = "23.6.20250307";
  baseUrl = "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/${version}";

  platformMapping = {
    "x86_64-linux" = "Linux";
    "aarch64-linux" = "ARM64";
    "x86_64-darwin" = "Darwin";
    "aarch64-darwin" = "Silicon";
  };

  currentPlatform =
    platformMapping.${stdenv.hostPlatform.system}
      or (throw "Unsupported System: ${stdenv.hostPlatform.system}");

  # hash attribute set for binary tools
  hashes = {
    # main edirect binary zip
    "edirect.tar.gz" = "sha256-nkb2NbsXvrRDHS5TK1YWwd1QyDWEGP4xMbrYH6qItE8=";
    # tool hashes - organized by tool then platform
    "xtract" = {
      "Linux" = "sha256-zUmHB5CYWaWCchIHBkZ+BEohGBSy8wB9LyVKqgTs5uM=";
      "ARM64" = "sha256-UjgW5WDgI7Q7su5WosN508dmjIZ6M43XynikwA0cKWA=";
      "Darwin" = "sha256-ignbBwvIf7YRDrBjlq+mQa4NA2BPs/IXdlkOX6wINlI=";
      "Silicon" = "sha256-D+u3VANaPAm1G0CBl1rdprgadftDHC87sus08F5ngdY=";
    };
    "rchive" = {
      "Linux" = "sha256-YgXgitvfb/fr7AVANygQTbrClV3RlQD8AvRn2N+Xr2Y=";
      "ARM64" = "sha256-We3fNfRUGVvNuzzg+1HK/JkTu4m4GONee4EXkZ5/dyE=";
      "Darwin" = "sha256-LA42ph41CwhCUGU6/pfp+0jDuyF5F5B2sqxRc7qWXyE=";
      "Silicon" = "sha256-kYig4y0lA16sX3wxQgfK4B6vc0fVjAHxgol8/y0cOUY=";
    };
    "transmute" = {
      "Linux" = "sha256-tHqzIj2NL1OZLZphPmf/t6dCAc3SdWFPDqeqPSdUe2g=";
      "ARM64" = "sha256-I0cGvBAso2sBjtLuLaPPz9HsbeseSFdozw5nMA0PGnc=";
      "Darwin" = "sha256-RSEZGvoOQ/ZzZd3B086dVDUX0Q9U7P5+OKLilFvD8KY=";
      "Silicon" = "sha256-FIxKoWGlg8pGVHz8YQ1G1Hz4e1BaHOS760knHG52fNQ=";
    };
  };

  mainArchive = fetchurl {
    url = "${baseUrl}/edirect.tar.gz";
    hash = hashes."edirect.tar.gz";
  };

  # List of binary tools to install
  tools = [
    "xtract"
    "rchive"
    "transmute"
  ];

  # List of essential edirect tools to install
  essentialCommands = [
    "nquire"
    "esearch"
    "efetch"
    "elink"
    "efilter"
    "einfo"
    "xtract"
    "transmute"
    "rchive"
    "xfetch"
    "xinfo"
    "xsearch"
    "xfilter"
    "xlink"
    "custom-index"
    "xy-plot"
    "epost"
  ];

  # List of commands to test (excludes custom-index)
  commandsToTest = [
    "nquire"
    "esearch"
    "efetch"
    "elink"
    "efilter"
    "einfo"
    "xtract"
    "transmute"
    "rchive"
    "xfetch"
    "xinfo"
    "xsearch"
    "xfilter"
    "xlink"
    "xy-plot"
    "epost"
  ];

  # Common path additions for wrappers
  commonPath = lib.makeBinPath [
    perl
    curl
    which
  ];

  # Function to fetch a binary tool for current platform
  fetchTool =
    name:
    fetchurl {
      url = "${baseUrl}/${name}.${currentPlatform}.gz";
      hash = hashes.${name}.${currentPlatform};
    };

  # Common wrapper environment settings
  makeCommonWrapper = source: target: extraArgs: ''
    makeWrapper ${source} ${target} \
      --prefix PATH : "${commonPath}:$out/bin" \
      ${extraArgs}
  '';

  # Wrapper for Perl scripts
  makePerlWrapper = script: name: ''
    ${makeCommonWrapper script "$out/bin/${name}" ''
      --prefix PERL5LIB : "$out/edirect" \
      --set EDIRECT_PUBMED_MASTER "1" \
      --set EDIRECT_TOOLSET_MASTER "1"
    ''}
  '';

  # Wrapper for shell scripts
  makeShellWrapper = script: name: ''
    ${makeCommonWrapper script "$out/bin/${name}" ""}
  '';

in
stdenv.mkDerivation (finalAttrs: {
  pname = "edirect";
  inherit version;

  src = mainArchive;

  nativeBuildInputs = [
    makeWrapper
    gzip
    perl
    curl
    which
    gnutar
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Create directories
    mkdir -p $out/{bin,edirect}

    # Extract main archive
    tar xzf $src -C $out

    # Process and install binary tools with their correct names
    cd $out/edirect
    mkdir -p bins

    # Process each binary tool
    ${lib.concatMapStrings (tool: ''
      # Unzip the binary for ${tool}
      gunzip -c ${fetchTool tool} > bins/${tool}
      chmod +x bins/${tool}

      # Create direct wrapper for the binary in bin directory
      ${makeShellWrapper "$out/edirect/bins/${tool}" tool}
    '') tools}

    # Process Perl and Shell scripts with extensions
    for scriptType in "pl" "sh"; do
      find $out/edirect -name "*.$scriptType" -type f -executable | while read script; do
        name=$(basename "$script" .$scriptType)

        if [[ "$scriptType" == "pl" ]]; then
          ${makePerlWrapper "$script" "$name"}
        else
          ${makeShellWrapper "$script" "$name"}
        fi
      done
    done

    # Process scripts without extensions (based on shebang)
    find $out/edirect -type f -executable -not -path "*/\.*" -not -path "$out/edirect/bins/*" | \
    grep -v "\.pl$\|\.sh$" | while read script; do
      name=$(basename "$script")

      # Skip if we've already created a wrapper for this name
      if [ -f "$out/bin/$name" ]; then
        echo "Skipping duplicate command: $name"
        continue
      fi

      # Create appropriate wrapper based on shebang
      if head -n 1 "$script" | grep -q "perl"; then
        echo "Creating wrapper for Perl script: $name"
        ${makePerlWrapper "$script" "$name"}
      elif head -n 1 "$script" | grep -q "bash\|sh"; then
        echo "Creating wrapper for shell script: $name"
        ${makeShellWrapper "$script" "$name"}
      elif head -n 1 "$script" | grep -q "^#!"; then
        echo "Creating wrapper for other script: $name"
        ${makeShellWrapper "$script" "$name"}
      fi
    done

    # Ensure all essential commands are available
    for cmd in ${lib.concatStringsSep " " essentialCommands}; do
      if [ ! -f "$out/bin/$cmd" ] && [ -f "$out/edirect/$cmd" ]; then
        echo "Creating wrapper for essential command: $cmd"
        ${makePerlWrapper "$out/edirect/$cmd" "$cmd"}
      fi
    done

    runHook postInstall
  '';

  passthru = {
    tests = {
      basic =
        runCommand "edirect-basic-test"
          {
            buildInputs = [ finalAttrs.finalPackage ];
          }
          ''
            # Test commands, excluding custom-index
            for cmd in ${lib.concatStringsSep " " commandsToTest}; do
              echo "Testing $cmd..."
              $cmd --help >/dev/null 2>&1 || { echo "$cmd failed"; exit 1; }
            done

            echo "All commands responded to --help" > $out
          '';
    };
  };

  meta = {
    description = "NCBI Entrez Direct (EDirect) Utility for accessing the NCBI's set of databases";
    homepage = "https://www.ncbi.nlm.nih.gov/books/NBK179288/";
    license = lib.licenses.publicDomain;
    platforms = builtins.attrNames platformMapping;
    maintainers = with lib.maintainers; [ mulatta ];
    mainProgram = "esearch";
  };
})
