{ lib
, stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  pname = "databricks-cli";
  version = "0.209.1";

  src = {
    x86_64-linux = fetchurl {
      url = "https://github.com/databricks/cli/releases/download/v${version}/databricks_cli_${version}_linux_amd64.zip";
      sha256 = "sha256-E69QpKsZxysc6duq3sz392qG/AtfvYEwzyvUgDWxkVE=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/databricks/cli/releases/download/v${version}/databricks_cli_${version}_linux_arm64.zip";
      sha256 = "sha256-UTPXMnrma66+lrXFKdfih5yJfAoQVBIHawzZ3yEdXOM=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/databricks/cli/releases/download/v${version}/databricks_cli_${version}_darwin_amd64.zip";
      sha256 = "sha256-GDoxPpfqsJShxtNeQ7uZTZw7sRlaNRES+sPribxNllI=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/databricks/cli/releases/download/v${version}/databricks_cli_${version}_darwin_arm64.zip";
      sha256 = "sha256-jyIoYTHJ/8lbBBVB5sUCCOdC7LCcTWywE5g3fOHa7XY=";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  doCheck = true;
  checkPhase = ''
    $installPhase/databricks --version
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp databricks $out/bin/
  '';

  meta = with lib; {
    description = "A command-line interface for Databricks";
    homepage = "https://github.com/databricks/cli";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ jl178 ];
  };
}
