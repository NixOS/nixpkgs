{ lib, buildGoModule, fetchFromGitHub, darwin, libiconv, alsa-lib, stdenv }:

buildGoModule rec {
  pname = "sampler";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "sqshq";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lanighxhnn28dfzils7i55zgxbw2abd6y723mq7x9wg1aa2bd0z";
  };

  vendorSha256 = "04nywhkil5xkipcibrp6vi63rfcvqgv7yxbxmmrhqys2cdxfvazv";

  doCheck = false;

  subPackages = [ "." ];

  buildInputs = lib.optional stdenv.isLinux alsa-lib
    ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.OpenAL
  ];

  meta = with lib; {
    description = "Tool for shell commands execution, visualization and alerting";
    homepage = "https://sampler.dev";
    license = licenses.gpl3;
    maintainers = with maintainers; [ uvnikita ];
    platforms = platforms.unix;
  };
}
