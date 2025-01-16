{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "ayano";
  version = "0.0.10";
  src = fetchFromGitHub {
    owner = "taoky";
    repo = "ayano";
    rev = "v${version}";
    sha256 = "sha256-d34Fhhk/qKsV6LDQ8VjssrH6u9lCpVE4+JLyBO7rXQA=";
  };
  vendorHash = "sha256-4X5hUc8MC3nncAt/2x3XRbcu3esVzGKHI4WesBwZfbM=";

  meta = {
    description = "Follow nginx log, and find out bad guys!";
    homepage = "https://github.com/taoky/ayano";
    license = "MIT";
    maintainers = with lib.maintainers; [
      taoky
      undefined-moe
    ];
  };
}
