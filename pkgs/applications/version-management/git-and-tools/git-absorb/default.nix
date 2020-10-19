{ stdenv, fetchFromGitHub, rustPlatform, installShellFiles, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-absorb";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner  = "tummychow";
    repo   = pname;
    rev    = "refs/tags/${version}";
    sha256 = "12ih0gm07ddi86jy612f029nzav345v57pjajyy9lw017g6n6mjb";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  cargoSha256 = "0x2zcw0bpwqimvbb5xj8xawvl4jcvk5lj0y2mm5ncbdapzyqdsb2";

  postInstall = ''
    installManPage Documentation/git-absorb.1
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/tummychow/git-absorb";
    description = "git commit --fixup, but automatic";
    license = [ licenses.bsd3 ];
    maintainers = [ maintainers.marsam ];
  };
}
