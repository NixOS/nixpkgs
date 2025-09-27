{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "jprq";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "azimjohn";
    repo = "jprq";
    tag = version;
    hash = "sha256-0+ope89NTODwFVNifXtq+yVLMMcf0bQT/XF3KyTfB0U=";
  };

  vendorHash = "sha256-aK+7ca16jzvKEDEWjCiud52vHciy1ZUwlSxKjd6rc+U=";

  subPackages = [
    "cli"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/jprq
  '';

  meta = {
    description = "Free and open tool for exposing local servers to public network";
    homepage = "https://jprq.io";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mmkamron ];
  };
}
