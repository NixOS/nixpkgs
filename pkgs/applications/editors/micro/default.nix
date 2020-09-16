{ stdenv, buildGoPackage, fetchFromGitHub, installShellFiles }:

buildGoPackage rec {
  pname = "micro";
  version = "2.0.7";

  goPackagePath = "github.com/zyedidia/micro";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = pname;
    rev = "v${version}";
    sha256 = "07ck1a9arklic3p0z50wcg608cvpba1kljvlfb4fljr6jhv5cmkb";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/micro" ];

  buildFlagsArray = let t = "${goPackagePath}/internal/util"; in ''
    -ldflags=
      -X ${t}.Version=${version}
      -X ${t}.CommitHash=${src.rev}
  '';

  goDeps = ./deps.nix;

  postInstall = ''
    installManPage $src/assets/packaging/micro.1
  '';

  meta = with stdenv.lib; {
    homepage = "https://micro-editor.github.io";
    description = "Modern and intuitive terminal-based text editor";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}

