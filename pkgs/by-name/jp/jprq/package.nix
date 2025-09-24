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
    repo = pname;
    rev = "v${version}";
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
    description = "join public router. quickly.";
    homepage = "https://jprq.io";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [mmkamron];
  };
}
