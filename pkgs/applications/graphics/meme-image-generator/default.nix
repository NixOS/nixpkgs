{ lib
, buildGoModule
, fetchFromGitHub
, updateGolangSysHook
}:

buildGoModule rec {
  pname = "meme-image-generator";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "nomad-software";
    repo = "meme";
    rev = "v${version}";
    sha256 = "089r0v5az2d2njn0s3d3wd0861pcs4slg6zl0rj4cm1k5cj8yd1k";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  deleteVendor = true;

  vendorSha256 = "sha256-y+bHei/044vW250DfLxAQpMsLr49vGw75NUxvuREsTQ=";

  meta = with lib; {
    description = "A command line utility for creating image macro style memes";
    homepage = "https://github.com/nomad-software/meme";
    license = licenses.mit;
    maintainers = [ maintainers.fgaz ];
    platforms = with platforms; linux ++ darwin;
  };
}
