{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  wrapGAppsHook3,
  CoreServices,
}:

rustPlatform.buildRustPackage rec {
  pname = "muso";
  version = "unstable-2021-09-02";

  src = fetchFromGitHub {
    owner = "quebin31";
    repo = pname;
    rev = "6dd1c6d3a82b21d4fb2606accf2f26179eb6eaf9";
    hash = "sha256-09DWUER0ZWQuwfE3sjov2GjJNI7coE3D3E5iUy9mlSE=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = lib.optional stdenv.hostPlatform.isDarwin CoreServices;

  preConfigure = ''
    substituteInPlace lib/utils.rs \
      --replace "/usr/share/muso" "$out/share/muso"
  '';

  postInstall = ''
    mkdir -p $out/share/muso
    cp share/* $out/share/muso/
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-L0ZQoz9J5Hxg98puk1RbKuybLboIoOsy5qqGnvEPi1U=";

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Automatic music sorter (based on ID3 tags)";
    mainProgram = "muso";
    homepage = "https://github.com/quebin31/muso";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ crertel ];
  };
}
