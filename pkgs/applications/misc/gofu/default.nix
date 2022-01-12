{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gofu";
  version = "unstable-2021-09-11";

  src = fetchFromGitHub {
    owner = "majewsky";
    repo = pname;
    rev = "cb398f58a5cb4f3e858fe60e84debde6ab58f7c8";
    sha256 = "sha256-R8Pr8SyLeoTaYKKV+PzHDPi1/RY4j7pkUbW8kE4ydBU=";
  };

  vendorSha256 = null;

  subPackages = [ "." ];

  postInstall = ''
    ln -s $out/bin/gofu $out/bin/rtree
    ln -s $out/bin/gofu $out/bin/prettyprompt
  '';

  meta = with lib; {
    description = "Multibinary containing several utilities";
    homepage = "https://github.com/majewsky/gofu";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
