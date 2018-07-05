{ stdenv, fetchFromGitHub, z3, zlib, git }:

stdenv.mkDerivation rec {
  version = "4.2.2";
  name = "vampire-${version}";

  src = fetchFromGitHub {
    owner = "vprover";
    repo = "vampire";
    rev = version;
    sha256 = "080zwgmyhn0b2c6hqlhcgaw7n3frz02sh894v5kk68kzxbqr29w2";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  nativeBuildInputs = [ git ];
  buildInputs = [ z3 zlib ];

  makeFlags = [ "vampire_z3_rel" ];

  fixupPhase = ''
    rm -rf z3
  '';

  installPhase = ''
    install -m0755 -D vampire_z3_rel* $out/bin/vampire
  '';

  meta = with stdenv.lib; {
    homepage = "https://vprover.github.io/";
    description = "The Vampire Theorem Prover";
    platforms = platforms.unix;
    license = licenses.unfree;
    maintainers = with maintainers; [ gebner ];
  };
}
