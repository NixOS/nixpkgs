{
  lib,
  stdenv,
  micro-headless,
  wl-clipboard,
  xclip,
  symlinkJoin,
  makeWrapper,

  # Boolean flags
  withXclip ? stdenv.isLinux,
  withWlClipboard ?
    if withWlclip != null then
      lib.warn ''
        withWlclip is deprecated and will be removed;
        use withWlClipboard instead.
      '' withWlclip
    else
      stdenv.isLinux,
  # Deprecated options
  # Remove them before or right after next version update from Nixpkgs or this
  # package itself
  withWlclip ? null,
}:

let
  clipboardPackages =
    lib.optionals withXclip [ xclip ]
    ++ lib.optionals withWlClipboard [ wl-clipboard ];
in

symlinkJoin rec {
  pname = "micro";
  inherit (micro-headless) version outputs meta;
  name = "${pname}-${version}";

  paths = [ micro-headless ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild =
    lib.concatLines (
      lib.forEach (lib.remove "out" micro-headless.outputs) (
        output: "ln -s --no-target-directory ${micro-headless.${output}} \$${output}"
      )
    )
    + lib.optionalString (clipboardPackages != [ ]) ''
      rm $out/bin/micro
      makeWrapper ${micro-headless}/bin/micro $out/bin/micro \
        --prefix PATH : "${lib.makeBinPath clipboardPackages}"
    '';
}
