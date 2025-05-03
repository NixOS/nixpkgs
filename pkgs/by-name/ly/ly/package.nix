{
  stdenv,
  lib,
  fetchFromGitHub,
  linux-pam,
  libxcb,
  makeBinaryWrapper,
  zig_0_13,
  callPackage,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "ly";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "fairyglade";
    repo = "ly";
    rev = "v1.0.3";
    hash = "sha256-TsEn0kH7j4myjjgwHnbOUmIZjHn8A1d/7IjamoWxpXQ=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    zig_0_13.hook
  ];
  buildInputs = [
    libxcb
    linux-pam
  ];

  postPatch = ''
    ln -s ${
      callPackage ./deps.nix {
        zig = zig_0_13;
      }
    } $ZIG_GLOBAL_CACHE_DIR/p
  '';

  passthru.tests = { inherit (nixosTests) ly; };

  meta = with lib; {
    description = "TUI display manager";
    license = licenses.wtfpl;
    homepage = "https://github.com/fairyglade/ly";
    maintainers = [ maintainers.vidister ];
    platforms = platforms.linux;
    mainProgram = "ly";
  };
}
