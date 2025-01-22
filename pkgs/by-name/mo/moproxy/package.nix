{
  fetchFromGitHub,
  rustPlatform,
  fetchurl,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "moproxy";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "sorz";
    repo = "moproxy";
    rev = "v${version}";
    hash = "sha256-Rqno+cg44IWBJbKWUP6BnxzwCjuNhFo9nBF6u2jlyA4=";
  };

  cargoHash = "sha256-EunlvI7I6d93wb3hxgxsyAXkzxRlDu0fq9qqjnbzzWg=";

  preBuild =
    let
      webBundle = fetchurl {
        url = "https://github.com/sorz/moproxy-web/releases/download/v0.1.8/build.zip";
        hash = "sha256-bLC76LnTWR2/xnDcZtX/t0OUmP7vdI/o3TCRzG9eH/g=";
      };
    in
    ''
      # build script try to download from network
      sed -i '15s/.*/let zip_path = PathBuf::from("${
        lib.escape [ "/" ] (toString webBundle)
      }");/' build.rs
    '';

  meta = with lib; {
    homepage = "https://github.com/sorz/moproxy";
    description = "Transparent TCP to SOCKSv5/HTTP proxy on Linux written in Rust";
    license = licenses.mit;
    mainProgram = "moproxy";
    maintainers = with maintainers; [ oluceps ];
    platforms = platforms.linux;
  };
}
