{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wayland
, libxkbcommon
, fontconfig
, makeWrapper
, grim
}:
rustPlatform.buildRustPackage rec {
  pname = "watershot";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Kirottu";
    repo = "watershot";
    rev = "v${version}";
    hash = "sha256-QX6BxK26kcrg0yKJA7M+Qlr3WwLaykBquI6UK8wVtX4=";
  };

  cargoHash = "sha256-481E5/mUeeoaZ0N//tRWCyV8/sRRP6VdB06gB1whgzU=";

  nativeBuildInputs = [ pkg-config wayland makeWrapper ];

  buildInputs = [ wayland fontconfig libxkbcommon ];

  postInstall = ''
    wrapProgram $out/bin/watershot \
      --prefix PATH : ${lib.makeBinPath [ grim ]}
  '';

  meta = with lib; {
    platforms = with platforms; linux;
    description = "A simple wayland native screenshot tool";
    homepage = "https://github.com/Kirottu/watershot";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lord-valen ];
  };
}
