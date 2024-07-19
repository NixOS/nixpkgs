{ lib
, stdenv
, fetchFromGitHub
, rust
, rustPlatform
, cmake
, just
, pkg-config
, libxkbcommon
, linux-pam
, wayland
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-greeter";
  version = "unstable-2023-11-08";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "a497ed8b1e67aaa9eb878d4ba225b40a71e1706c";
    sha256 = "sha256-P37i0JYP21gGE7NIq9G3WVUa0vv2MdFJmo/GuRDuV8A=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.11.0" = "sha256-/6KUCH1CwMHd5YEMOpAdVeAxpjl9JvrzDA4Xnbd1D9k=";
      "cosmic-bg-config-0.1.0" = "sha256-fdRFndhwISmbTqmXfekFqh+Wrtdjg3vSZut4IAQUBbA=";
      "cosmic-config-0.1.0" = "sha256-c2pGujYQ3WbbiHGhPo2kG8/NiydmpfFNQrlrb1nk/RY=";
      "smithay-client-toolkit-0.17.0" = "sha256-vDY4cqz5CZD12twElUWVCsf4N6VO9O+Udl8Dc4arWK4=";
      "softbuffer-0.2.0" = "sha256-VD2GmxC58z7Qfu/L+sfENE+T8L40mvUKKSfgLmCTmjY=";
      "taffy-0.3.11" = "sha256-8gctP/nRiYxTSDrLyXi/oQbA7bE41ywgMbyotY1N8Zk=";
    };
  };

  nativeBuildInputs = [ rustPlatform.bindgenHook cmake just pkg-config ];
  buildInputs = [ libxkbcommon wayland linux-pam ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${rust.lib.toRustTargetSpecShort stdenv.hostPlatform}/release/cosmic-greeter"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-greeter";
    description = "Greeter for the COSMIC Desktop Environment";
    mainProgram = "cosmic-greeter";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
  };
}
