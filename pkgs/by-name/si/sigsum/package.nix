{
  lib,
  buildGoModule,
  fetchFromGitLab,
  fetchpatch2,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "sigsum";
  version = "0.14.1";

  src = fetchFromGitLab {
    domain = "git.glasklar.is";
    group = "sigsum";
    owner = "core";
    repo = "sigsum-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZiU5eEI2pKknpjc3HU9EqQu6u1ZD/N7sOD0DyTma0/g=";
  };

  # FIXME: remove in next release
  patches = [
    (fetchpatch2 {
      url = "https://github.com/sigsum/sigsum-go/commit/f96375480607612154814e0442b3428696cf35f5.patch?full_index=1";
      hash = "sha256-MR151ZVfrYniyDGzVonLNKcBAHEflAgjULBfp+vhFvg=";
    })
    (fetchpatch2 {
      url = "https://github.com/sigsum/sigsum-go/commit/bbf212c19dfc9af66f102f3932381e9476428966.patch?full_index=1";
      hash = "sha256-fPMIdcH22hVMKiARPQSJ3W/1q74LuALbaf9B5TtzD/o=";
    })
    (fetchpatch2 {
      url = "https://github.com/sigsum/sigsum-go/commit/5e7b309d82a34d60872441573eb843c343bc43ba.patch?full_index=1";
      hash = "sha256-yvKkeJxaGi353X+zlrbpLiYj/q34cuGcuVWn1ghab1s=";
    })
  ];

  postPatch = ''
    substituteInPlace internal/version/version.go \
      --replace-fail "info.Main.Version" '"${finalAttrs.version}"'
  '';

  vendorHash = "sha256-BaN9NslTvVyIp1Gi0N3UKdTXCd5opdL6Fb0AVoy9diM=";

  ldflags = [
    "-s"
    "-w"
  ];

  excludedPackages = [ "./test" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/sigsum-key";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^v(\\d+\\.\\d+\\.\\d+)$" ];
  };

  meta = {
    description = "System for public and transparent logging of signed checksums";
    homepage = "https://www.sigsum.org/";
    downloadPage = "https://git.glasklar.is/sigsum/core/sigsum-go";
    changelog = "https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/v${finalAttrs.version}/NEWS";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ defelo ];
  };
})
