{ stdenv, lib, fetchFromGitHub, linux-pam, libxcb, makeBinaryWrapper, zig_0_12
, callPackage, nixosTests }:

stdenv.mkDerivation {
  pname = "ly";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "fairyglade";
    repo = "ly";
    rev = "v1.0.2";
    hash = "sha256-VUtNEL7Te/ba+wvL0SsUHlyv2NPmkYKs76TnW8r3ysw=";
  };

  nativeBuildInputs = [ makeBinaryWrapper zig_0_12.hook ];
  buildInputs = [ libxcb linux-pam ];

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
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
