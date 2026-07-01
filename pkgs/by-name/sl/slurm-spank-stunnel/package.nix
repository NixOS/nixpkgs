{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  slurm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "slurm-spank-stunnel";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "stanford-rc";
    repo = "slurm-spank-stunnel";
    rev = finalAttrs.version;
    sha256 = "15cpd49ccvzsmmr3gk8svm2nz461rvs4ybczckyf4yla0xzp06gj";
  };

  patches = [
    ./backward-compat.patch
    (fetchpatch {
      name = "hostlist_t-signature.patch";
      url = "https://github.com/stanford-rc/slurm-spank-stunnel/commit/84d04e4ccfe538a09c3f17a52dde616903b66db8.patch";
      sha256 = "sha256-RaUYqeNmFPvYci2yX8Bxps1nDjX/UAG+e3JbjbcwrO0=";
    })
  ];

  buildPhase = ''
    runHook preBuild

    gcc -I${lib.getDev slurm}/include -shared -fPIC -o stunnel.so slurm-spank-stunnel.c

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/etc/slurm/plugstack.conf.d
    install -m 755 stunnel.so $out/lib
    install -m 644 plugstack.conf $out/etc/slurm/plugstack.conf.d/stunnel.conf.example

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/stanford-rc/slurm-spank-stunnel";
    description = "Plugin for SLURM for SSH tunneling and port forwarding support";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ markuskowa ];
  };
})
