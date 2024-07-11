{ lib
, stdenv
, fetchFromGitHub
, curl
, ldc
, libevent
, rsync
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dub";
  version = "1.38.0";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "dlang";
    repo = "dub";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+cG7tR4nAL4fhk9/1FMkfjQ8Rtqf+uTvGfVegmnjloY=";
  };

  postPatch = ''
    patchShebangs test
  '';

  nativeBuildInputs = [ ldc libevent rsync ];
  buildInputs = [ curl ];

  buildPhase = ''
    runHook preBuild

    export DMD=${ldc}/bin/ldmd2
    ldc2 -run ./build.d

    runHook postBuild
  '';

  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    runHook preCheck

    export DUB=$NIX_BUILD_TOP/source/bin/dub
    export PATH=$PATH:$NIX_BUILD_TOP/source/bin/
    export DC=${lib.getExe ldc}
    export HOME=$TMP

    rm -rf test/issue502-root-import
    rm test/issue674-concurrent-dub.sh
    rm test/issue672-upgrade-optional.sh
    rm test/issue990-download-optional-selected.sh
    rm test/issue877-auto-fetch-package-on-run.sh
    rm test/issue1037-better-dependency-messages.sh
    rm test/issue1416-maven-repo-pkg-supplier.sh
    rm test/issue1180-local-cache-broken.sh
    rm test/issue1574-addcommand.sh
    rm test/issue1524-maven-upgrade-dependency-tree.sh
    rm test/issue1773-lint.sh

    rm test/ddox.sh
    rm test/fetchzip.sh
    rm test/feat663-search.sh
    rm -rf test/git-dependency
    rm test/interactive-remove.sh
    rm test/timeout.sh
    rm test/version-spec.sh
    rm test/0-init-multi.sh
    rm test/0-init-multi-json.sh
    rm test/4-describe-data-1-list.sh
    rm test/4-describe-data-3-zero-delim.sh
    rm test/4-describe-import-paths.sh
    rm test/4-describe-string-import-paths.sh
    rm test/4-describe-json.sh
    rm test/5-convert-stdout.sh
    rm test/issue1003-check-empty-ld-flags.sh
    rm test/issue103-single-file-package.sh
    rm test/issue1040-run-with-ver.sh
    rm test/issue1091-bogus-rebuild.sh
    rm test/issue1194-warn-wrong-subconfig.sh
    rm test/issue1277.sh
    rm test/issue1372-ignore-files-in-hidden-dirs.sh
    rm test/issue1447-build-settings-vars.sh
    rm test/issue1531-toolchain-requirements.sh
    rm test/issue346-redundant-flags.sh
    rm test/issue361-optional-deps.sh
    rm test/issue564-invalid-upgrade-dependency.sh
    rm test/issue586-subpack-dep.sh
    rm test/issue616-describe-vs-generate-commands.sh
    rm test/issue686-multiple-march.sh
    rm test/issue813-fixed-dependency.sh
    rm test/issue813-pure-sub-dependency.sh
    rm test/issue820-extra-fields-after-convert.sh
    rm test/issue923-subpackage-deps.sh
    rm test/single-file-sdl-default-name.sh
    rm test/subpackage-common-with-sourcefile-globbing.sh
    rm test/issue934-path-dep.sh
    rm -r test/issue2258-dynLib-exe-dep # requires files below
    rm -r test/1-dynLib-simple
    rm -r test/1-exec-simple-package-json
    rm -r test/1-exec-simple
    rm -r test/1-staticLib-simple
    rm -r test/2-dynLib-dep
    rm -r test/2-staticLib-dep
    rm -r test/2-dynLib-with-staticLib-dep
    rm -r test/2-sourceLib-dep/
    rm -r test/3-copyFiles
    rm -r test/custom-source-main-bug487
    rm -r test/custom-unittest
    rm -r test/issue1262-version-inheritance-diamond
    rm -r test/issue1003-check-empty-ld-flags
    rm -r test/ignore-hidden-1
    rm -r test/ignore-hidden-2
    rm -r test/issue1427-betterC
    rm -r test/issue130-unicode-*
    rm -r test/issue1262-version-inheritance
    rm -r test/issue1372-ignore-files-in-hidden-dirs
    rm -r test/issue1350-transitive-none-deps
    rm -r test/issue1775
    rm -r test/issue1447-build-settings-vars
    rm -r test/issue1408-inherit-linker-files
    rm -r test/issue1551-var-escaping
    rm -r test/issue754-path-selection-fail
    rm -r test/issue1788-incomplete-string-import-override
    rm -r test/subpackage-ref
    rm -r test/issue777-bogus-path-dependency
    rm -r test/issue959-path-based-subpack-dep
    rm -r test/issue97-targettype-none-nodeps
    rm -r test/issue97-targettype-none-onerecipe
    rm -r test/path-subpackage-ref
    rm -r test/sdl-package-simple
    rm -r test/dpath-variable # requires execution of dpath-variable.sh
    rm -r test/use-c-sources
    rm -r test/pr2642-cache-db
    rm -r test/pr2644-describe-artifact-path
    rm -r test/pr2647-build-deep

    ./test/run-unittest.sh

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/dub $out/bin/dub

    runHook postInstall
  '';

  meta = with lib; {
    description = "Package and build manager for D programs and libraries";
    homepage = "https://code.dlang.org/";
    license = licenses.mit;
    mainProgram = "dub";
    maintainers = with maintainers; [ jtbx ];
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
})
