{
  # eval deps
  buildNpmPackage,
  fetchpatch,
  fetchFromGitHub,
  lib,
  nix-update-script,

  # runtime deps
  certificate-ripper,
  nodejs_20,
  playwright-driver,
  playwright-test,
  yt-dlp,
}:
buildNpmPackage (finalAttrs: {
  pname = "scoop";
  version = "0.6.59";

  src = fetchFromGitHub {
    owner = "harvard-lil";
    repo = "scoop";
    tag = finalAttrs.version;
    hash = "sha256-KcoTl2ehla6ALLrpAyfOqDioP5s3CGVfVhsj3Fbq6/Y=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/harvard-lil/scoop/pull/414/commits/4dc4ee6d4e6c3fa89cf5ec4c685178f1927ffa1f.patch";
      hash = "sha256-zV7axS3zlD/hWwgZHTOkMLVak71giWy+J0iwZ3eSKL4=";
    })
  ];

  # scoop doesn't work on node 22+ https://github.com/harvard-lil/portal/issues/12
  nodejs = nodejs_20;

  npmDepsHash = "sha256-lx+MxV8JDArDMQ0OV4eDXOTzd7xRfvvpAGJp+jPQPgs=";

  env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

  dontNpmBuild = true;

  postInstall = ''
    scoop_npm_dir="$out/lib/node_modules/@harvard-lil/scoop"
    ln -s /tmp "$scoop_npm_dir"/tmp

    (
      cd -- "$scoop_npm_dir/node_modules"
      rm -rf playwright playwright-core
      ln -s ${playwright-test}/lib/node_modules/playwright
      ln -s ${playwright-test}/lib/node_modules/playwright-core
    )

    # reimplementing what scoop does in $src/postinstall.sh
    exe_dir="$scoop_npm_dir/executables"
    mkdir -p "$exe_dir"
    ln -s ${lib.getExe yt-dlp} "$exe_dir"/yt-dlp
    ln -s ${lib.getExe certificate-ripper} "$exe_dir"/crip
  '';

  makeWrapperArgs = [
    "--set-default"
    "PLAYWRIGHT_BROWSERS_PATH"
    playwright-driver.browsers
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High fidelity, browser-based, web archiving capture engine for witnessing the web";
    homepage = "https://github.com/harvard-lil/scoop";
    changelog = "https://github.com/harvard-lil/scoop/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      # from `find . -name 'package.json' -print0 | xargs -0 jq '.license' -r | sort -u` in the source dir after npm install
      bsd0
      agpl3Plus
      asl20
      blueOak100
      bsd2
      bsd3
      isc
      mit
      zlib
      psfl
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      # we don't know whats in those npm deps without digging
      binaryBytecode
      binaryNativeCode
    ];
    maintainers = [ lib.maintainers.shelvacu ];
    mainProgram = "scoop";
    platforms = lib.platforms.all;
  };
})
