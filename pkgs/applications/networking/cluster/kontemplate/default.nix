{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "kontemplate";
  version       = "1.8.0";
  goPackagePath = "github.com/tazjin/kontemplate";
  goDeps        = ./deps.nix;

  src = fetchFromGitHub {
    owner  = "tazjin";
    repo   = "kontemplate";
    rev    = "v${version}";
    sha256 = "123mjmmm4hynraq1fpn3j5i0a1i87l265kkjraxxxbl0zacv74i1";
  };

  meta = with lib; {
    description      = "Extremely simple Kubernetes resource templates";
    mainProgram = "kontemplate";
    homepage         = "http://kontemplate.works";
    downloadPage     = "https://github.com/tazjin/kontemplate/releases";
    license          = licenses.gpl3;
    maintainers      = with maintainers; [ mbode tazjin ];
    platforms        = platforms.unix;

    longDescription = ''
      Kontemplate is a simple CLI tool that can take sets of
      Kubernetes resource files with placeholders and insert values
      per environment.

      It can be used as a simple way of deploying the same set of
      resources to different Kubernetes contexts with context-specific
      configuration.
    '';
  };
}
