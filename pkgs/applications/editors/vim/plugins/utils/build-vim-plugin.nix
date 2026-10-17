{
  lib,
  stdenv,
  rtpPath,
  toVimPlugin,
}:

{
  addRtp = drv: lib.throw "`addRtp` has been removed.";

  buildVimPlugin =
    {
      name ? "${attrs.pname}-${attrs.version}",
      src,
      unpackPhase ? "",
      configurePhase ? ":",
      buildPhase ? ":",
      preInstall ? "",
      postInstall ? "",
      path ? ".",
      addonInfo ? null,
      meta ? { },
      ...
    }@attrs:
    let
      drv = stdenv.mkDerivation (
        attrs
        // {
          __structuredAttrs = true;
          inherit
            unpackPhase
            configurePhase
            buildPhase
            addonInfo
            preInstall
            postInstall
            ;

          installPhase =
            attrs.installPhase or ''
              runHook preInstall

              target=$out/${rtpPath}/${path}
              mkdir -p $out/${rtpPath}
              ${lib.optionalString (!(attrs.dontUnpack or false)) "cp -r . $target"}

              runHook postInstall
            '';

          meta = {
            platforms = lib.platforms.all;
          }
          // meta;
        }
      );
    in
    toVimPlugin drv;

}
