{ lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  rev = "4530cf8d59e1047cb1c005a6bd5b14ecb98b9e68";
  name = "drive-${lib.strings.substring 0 7 rev}";
  goPackagePath = "github.com/odeke-em/drive";
  src = fetchFromGitHub {
    inherit rev;
    owner = "odeke-em";
    repo = "drive";
    sha256 = "1y4qlzvgg84mh8l6bhaazzy6bv6dwjcbpm0rxvvc5aknvvh581ps";
  };

  subPackages = [ "cmd/drive" ];

  buildInputs = [ pb go-isatty command dts odeke-em.log statos xon odeke-em.google-api-go-client cli-spinner oauth2 text net ];

  dontInstallSrc = true;

  meta = with lib; {
    description = "A tiny program to pull or push Google Drive files";
    homepage = https://github.com/odeke-em/drive;
    license = licenses.asl20;
    maintainers = with maintainers; [ bobvanderlinden ];
    platforms = platforms.linux;
  };
}
