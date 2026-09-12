{
  lib,
  coreutils,
  fetchpatch,
  texinfo,
  makeWrapper,
}:

# Build standalone binaries so cp/mv exist as real files, not argv[0] dispatch
# symlinks into a single coreutils binary.
(coreutils.override { singleBinary = false; }).overrideAttrs (old: {
  pname = "advcpmv";

  # advcpmv patch version + the coreutils version it is applied to.
  # Note: keep `version` unchanged so coreutils' `src` URL (derived from
  # version) still resolves; expose the combined version via `name` instead.
  name = "advcpmv-0.9-${old.version}";

  # texinfo: the patch touches doc/coreutils.texi, so the info manual is
  # regenerated, which requires makeinfo.
  # makeWrapper: cpg/mvg are cp/mv wrappers that always pass --progress-bar.
  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
    texinfo
    makeWrapper
  ];

  patches = (old.patches or [ ]) ++ [
    (fetchpatch {
      name = "advcpmv-0.9-9.11.patch";
      url = "https://raw.githubusercontent.com/jarun/advcpmv/1a574b81d801ec29a78e0346eeecab0495bba0c8/advcpmv-0.9-9.11.patch";
      hash = "sha256-VCR7Vy8BXqd1Dc4ayORdoHc2cW1iv8PyZzWRbLHAQm8=";
    })
  ];

  # Wrap the patched cp/mv as cpg/mvg with --progress-bar always enabled, then
  # drop the other coreutils binaries.  cpg/mvg coexist with coreutils' cp/mv.
  postInstall = (old.postInstall or "") + ''
    install -Dm755 "$out/bin/cp" "$out/libexec/advcpmv/cp"
    install -Dm755 "$out/bin/mv" "$out/libexec/advcpmv/mv"
    find "$out/bin" -mindepth 1 -delete
    makeWrapper "$out/libexec/advcpmv/cp" "$out/bin/cpg" --add-flags --progress-bar
    makeWrapper "$out/libexec/advcpmv/mv" "$out/bin/mvg" --add-flags --progress-bar
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = (old.meta or { }) // {
    description = "GNU cp and mv with an added progress bar (-g/--progress-bar)";
    homepage = "https://github.com/jarun/advcpmv";
    mainProgram = "cpg";
    maintainers = with lib.maintainers; [ seanybaggins ];
  };
})
