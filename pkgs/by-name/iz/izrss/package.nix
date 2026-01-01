{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "izrss";
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "izrss";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-cBkq+Xq6FxizftYZ1YelYdubWNakLbkhGE55hkOr4Qo=";
=======
    hash = "sha256-t+RtdKrYI0MNGSR1ABvClKv+hUJ4Tpg7yKS2qbm7BKc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

<<<<<<< HEAD
  vendorHash = "sha256-hiqheaGCtybrK5DZYz2GsYvTlUZDGu04wDjQqfE7O3k=";
=======
  vendorHash = "sha256-2L/EUoPbz6AZqv84XPhiZhImOL4wyBOzx6Od4+nTJeY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "RSS feed reader for the terminal written in Go";
    changelog = "https://github.com/isabelroses/izrss/releases/v${finalAttrs.version}";
    homepage = "https://github.com/isabelroses/izrss";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      isabelroses
      luftmensch-luftmensch
    ];
    mainProgram = "izrss";
  };
})
