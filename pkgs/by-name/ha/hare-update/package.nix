{
  fetchFromSourcehut,
  hareHook,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hare-update";
  version = "0.26.0.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-update";
    tag = finalAttrs.version;
    hash = "sha256-E6N9UMYdNTgy0tppBgOwT14WUXvjliSh/ps16fPDFN8=";
  };

  nativeBuildInputs = [
    hareHook
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Tool for assisting in updating Hare codebases affected by breaking changes";
    longDescription = ''
      hare-update is a Hare add-on which assists in migrating a Hare codebases
      to a newer release of Hare by scanning your code, identifying areas
      impacted by breaking changes, and suggesting the appropriate fix.
    '';
    homepage = "https://git.sr.ht/~sircmpwn/hare-update";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ snifexx ];
    # Same as the harec package except with added netbsd. harec also supports netbsd, so...
    platforms =
      with lib.platforms;
      lib.intersectLists (netbsd ++ freebsd ++ openbsd ++ linux) (aarch64 ++ x86_64 ++ riscv64);
    # Same as the harec package. The harec developers do not explicitly supprt
    # MacOS, even if ports exists
    badPlatforms = lib.platforms.darwin;
  };
})
