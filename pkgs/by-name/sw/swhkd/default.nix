{lib, rustPlatform, fetchFromGitHub, pkg-config, pkgs }:

  rustPlatform.buildRustPackage rec {
    pname = "swhkd";
    version = "1.2.1";

    src = fetchFromGitHub {
        owner = "waycrate";
        repo = "swhkd";
        rev = "refs/tags/${version}";
        hash = "sha256-VQW01j2RxhLUx59LAopZEdA7TyZBsJrF1Ym3LumvFqA=";
      };

    nativeBuildInputs = with pkgs; [
      pkg-config
    ];

    cargoHash = "sha256-NAVqwYJA0+X0dFC3PBaW+QJxvJtSgl4Y/VNfNO3jnLA=";

    preBuild = ''
      cargo generate-lockfile
    '';

    buildInputs = with pkgs; [
      systemd
      gcc.cc.libgcc
    ];

    meta = with lib; {
        description = "Wayland fork of sxhkd";
        homepage = "https://github.com/waycrate/swhkd";
        license = licenses.bsd2;
        maintainers = with maintainers; [ WhenFreedom ];
        mainProgram = "swhkd";
      };
  }
