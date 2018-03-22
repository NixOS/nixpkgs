{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name          = "kontemplate-${version}";
  version       = "1.4.0";
  goPackagePath = "github.com/tazjin/kontemplate";
  goDeps        = ./deps.nix;

  src = fetchFromGitHub {
    owner  = "tazjin";
    repo   = "kontemplate";
    rev    = "v${version}";
    sha256 = "11aqc9sgyqz3pscx7njnb3xghl7d61vzdgl3bqndady0dxsccrpj";
  };

  meta = with lib; {
    description      = "Extremely simple Kubernetes resource templates";
    homepage         = "http://kontemplate.works";
    downloadPage     = "https://github.com/tazjin/kontemplate/releases";
    license          = licenses.gpl3;
    maintainers      = with maintainers; [ mbode tazjin ];
    platforms        = platforms.unix;
    repositories.git = git://github.com/tazjin/kontemplate.git;

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
