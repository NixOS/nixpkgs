{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ocplib_stuff,
  ez_subst,
  cmdliner,
  ppx_inline_test,
  ppx_expect,
}:
buildDunePackage (finalAttrs: {
  pname = "ez_cmdliner";
  version = "0.5.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ez_cmdliner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YZJLFoPlbGmbizapkrAofbrRRnUI4axW9fTwDpVv27U=";
  };

  propagatedBuildInputs = [
    ocplib_stuff
    ez_subst
    cmdliner
    ppx_inline_test
    ppx_expect
  ];

  doCheck = true;

  meta = {
    description = "Easy Cmdliner";
    homepage = "https://github.com/OCamlPro/ez_cmdliner";
    license = lib.licenses.WITH lib.licenses.lgpl21Only lib.licenses.ocamlLgplLinkingException;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
  };
})
