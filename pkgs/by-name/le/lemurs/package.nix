{
  fetchFromGitHub,
  lib,
  linux-pam,
  rustPlatform,
  testers,
  lemurs,
}:
rustPlatform.buildRustPackage rec {
  pname = "lemurs";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "coastalwhite";
    repo = "lemurs";
    rev = "v${version}";
    hash = "sha256-YDopY+wdWlVL2X+/wc1tLSSqFclAkt++JXMK3VodD4s=";
  };

  patches = [
    # part of https://github.com/coastalwhite/lemurs/commit/09003a830400250ec7745939399fc942c505e6c6, but including the rest of the commit may be breaking
    ./0001-fix-static-lifetime-string.patch
  ];

  cargoHash = "sha256-uuHPJe+1VsnLRGbHtgTMrib6Tk359cwTDVfvtHnDToo=";

  buildInputs = [
    linux-pam
  ];

  passthru.tests.version = testers.testVersion {
    package = lemurs;
  };

  meta = with lib; {
    description = "Customizable TUI display/login manager written in Rust";
    homepage = "https://github.com/coastalwhite/lemurs";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ jeremiahs ];
    mainProgram = "lemurs";
  };
}
