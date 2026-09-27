{
  lib,

  cmake,
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libjuice";
  version = "1.7.1";

  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "paullouisageneau";
    repo = "libjuice";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dFZ4IpcNpPJwfamJHAvc0pwAZu2DT/af4VraXx/fdRc=";
  };

  nativeBuildInputs = [ cmake ];

  postInstall = ''
    mkdir -p $dev/lib/pkgconfig
    substitute ${builtins.path { path = ./juice.pc; }} $dev/lib/pkgconfig/juice.pc \
      --subst-var out \
      --subst-var dev \
      --subst-var pname \
      --subst-var version \
      --subst-var-by description ${lib.escapeShellArg finalAttrs.meta.description}
  '';

  __structuredAttrs = true;

  meta = {
    description = "Library for opening bidirectional UDP streams with NAT traversal";
    homepage = "https://github.com/paullouisageneau/libjuice";
    downloadPage = "https://github.com/paullouisageneau/libjuice/releases";
    changelog = "https://github.com/paullouisageneau/libjuice/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.shelvacu ];
    platforms = lib.platforms.all;
  };
})
