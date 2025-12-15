{ melpaBuild, ott }:

melpaBuild {
  pname = "ott-mode";

  inherit (ott) src version;

  files = ''("emacs/*.el")'';

  postPatch = ''
    pushd emacs
    echo ";;; ott-mode.el ---" > tmp.el
    cat ott-mode.el >> tmp.el
    mv tmp.el ott-mode.el
    popd
  '';

  meta = {
    description = "Emacs ott mode (from ott sources)";
    inherit (ott.meta) homepage license;
  };
}
