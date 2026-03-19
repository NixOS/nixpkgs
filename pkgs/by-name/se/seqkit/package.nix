{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "seqkit";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "seqkit";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-IZhQHB96uFQGfAqCJiT4EdkDT605EHu7eSQa/i4d3hQ=";
  };

  vendorHash = "sha256-HDyytwFIfvDGMmcMVH0F2NAttygTUu8PS4RvKK0TzLE=";

  meta = {
    description = "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation";
    homepage = "https://github.com/shenwei356/seqkit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bzizou ];
  };
})
