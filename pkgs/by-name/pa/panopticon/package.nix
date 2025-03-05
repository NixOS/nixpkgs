{ lib, fetchFromGitHub, rustPlatform, qt5, git, cmake
, pkg-config, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "panopticon";
  version = "unstable-20171202";

  src = fetchFromGitHub {
    owner = "das-labor";
    repo = pname;
    rev = "33ffec0d6d379d51b38d6ea00d040f54b1356ae4";
    sha256 = "1zv87nqhrzsxx0m891df4vagzssj3kblfv9yp7j96dw0vn9950qa";
  };

  nativeBuildInputs = [ cmake pkg-config makeWrapper ];
  propagatedBuildInputs = with qt5; [
     qt5.qtbase
     qtdeclarative
     qtsvg
     qtquickcontrols2
     qtgraphicaleffects
     git
  ];

  dontWrapQtApps = true;

  cargoHash = "sha256-VQG7WTubznDi7trrnZIPB5SLfvYUzWxHh+z9wOdYDG4=";
  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/${pname} $out/bin
    cp -R qml $out/share/${pname}
    mv $out/bin/${pname} $out/share/${pname}
    chmod +x $out/share/${pname}
    makeWrapper $out/share/${pname}/${pname} $out/bin/${pname}
     '';

  meta = with lib; {
    description = "Libre cross-platform disassembler";
    longDescription = ''
      Panopticon is a cross platform disassembler for reverse
      engineering written in Rust. It can disassemble AMD64,
      x86, AVR and MOS 6502 instruction sets and open ELF files.
      Panopticon comes with Qt GUI for browsing and annotating
      control flow graphs.
    '';
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ leenaars ];
    broken = true; # Added 2024-03-16
  };
}
