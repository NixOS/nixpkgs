{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  libxcrypt,
}:

stdenv.mkDerivation rec {
  pname = "pgsql-tools";
  version = "2.0.6";

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      arch = selectSystem {
        x86_64-linux = "linux-x64";
        aarch64-linux = "linux-arm64";
      };
    in
    fetchurl {
      url = "https://github.com/microsoft/pgsql-tools/releases/download/v${version}/pgsqltoolsservice-${arch}.tar.gz";

      # When updating to a new version, use the ./fetch_hashes.sh script to calculate the hash for each architecture
      sha256 = selectSystem {
        aarch64-linux = "1vai84yqk34rkbddczvfr3m1g8d7hhcdigm4rk6zff4zhq133k4r";
        x86_64-linux = "101504x7lc98kfmzfp7mna48qcsf5df77f5y28asgnwysb1jjvq1";
      };
    };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ libxcrypt ];

  installPhase = ''
    mkdir -p $out/bin
    cp ossdbtoolsservice_main $out/bin/
    cp -r _internal $out/bin/
  '';

  meta = with lib; {
    homepage = "https://github.com/microsoft/pgsql-tools";
    description = "PostgreSQL tools service is a backend service for PostgreSQL server tools, offering features such as connection management, query execution with result set handling, and language service support via the VS Code protocol.";
    changelog = "https://github.com/microsoft/pgsql-tools/releases";
    license = with licenses; [ mit ];
    platforms = lib.platforms.linux;
    maintainers = with maintainers; [ rutgerdj ];
    mainProgram = "ossdbtoolsservice_main";
  };
}
