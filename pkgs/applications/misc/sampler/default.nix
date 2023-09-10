{ lib, buildGoModule, fetchFromGitHub, fetchpatch, darwin, libiconv, alsa-lib, stdenv }:

buildGoModule rec {
  pname = "sampler";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "sqshq";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lanighxhnn28dfzils7i55zgxbw2abd6y723mq7x9wg1aa2bd0z";
  };

  patches = [
    # fix build with go 1.17
    (fetchpatch {
      url = "https://github.com/sqshq/sampler/commit/97a4a0ebe396a780d62f50f112a99b27044e832b.patch";
      sha256 = "1czns7jc85mzdf1mg874jimls8x32l35x3lysxfgfah7cvvwznbk";
    })
  ];

  vendorSha256 = "02cfzqadpsk2vkzsp7ciji9wisjza0yp35pw42q44navhbzcb4ji";

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
  };
}
