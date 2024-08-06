{
  lib,
  stdenvNoCC,
  fetchurl,
  jq,
  fonts ? [ ],
}:
let
  # We don't use a fixed list of URLs like we do for hashes here. At
  # the expense of 1 more tiny HTTP request, we get the ability to
  # check when this goes out of date, based on this hash breaking,
  # versus a bunch of CDN links failing otherwise, which may be harder
  # to debug (network issues could be a factor, for example).
  #
  # There is really no way to know how long the CDN links will persist
  # after an update, as this API does not have any kind of way to pin
  # versions.
  fonts-data = lib.importJSON (fetchurl {
    url = "https://api.fontshare.com/v2/fonts";
    hash = "sha256-JEHNm/nujIE3acuD21Mei02+Jl3DOWdVejfOuPY/eew=";
    postFetch = ''
      OUT_TMP=$(mktemp)
      # Take only the data we need; the rest is superfluous (and I've seen it change randomly)
      jq -c "[.fonts[] | {license_type: .license_type, name: .name, slug: .slug, styles: [.styles[] | ({file: .file, name: .weight.name})]}]" $out > $OUT_TMP
      cat $OUT_TMP > $out
    '';
    nativeBuildInputs = [ jq ];
  });
  hashes = import ./hashes.nix;
  all-fonts = lib.foldl (
    acc: font:
    lib.setAttr acc font.name {
      license =
        if font.license_type == "itf_ffl" then
          lib.licenses.itf-ffl
        else if font.license_type == "sil_ofl" then
          lib.licenses.ofl
        else
          lib.warn "fontshare-fonts: Unknown license found while fetching list of fonts." lib.licenses.unfree;
      srcs = lib.map (style: {
        url = "https:${style.file}.ttf";
        name = "${font.slug}-${style.name}.ttf";
        hash = lib.getAttr "${font.slug}-${style.name}" hashes;
      }) font.styles;
    }
  ) { } fonts-data;
  fonts' = lib.map (
    font:
    lib.warnIf (
      !(lib.hasAttr font all-fonts)
    ) "fontshare-fonts: Unknown font \"${font}\" requested." font
  ) fonts;
  selected-fonts =
    if fonts == [ ] then
      all-fonts
    else if fonts == "free" then
      lib.filterAttrs (_: font: font.license == lib.licenses.ofl) all-fonts
    else
      lib.filterAttrs (name: _: lib.elem name fonts') all-fonts;
  licenses = lib.foldl (
    acc: font: if lib.elem font.license acc then acc else acc ++ [ font.license ]
  ) [ ] (lib.attrValues selected-fonts);
in
stdenvNoCC.mkDerivation {
  pname = "fontshare-fonts";
  # Upstream is not versioned or permalinked. Oops
  version = "unstable-2024-07-30";

  # Unfortunately, the prebuilt zip is re-built each time a request is
  # made and thus we can't(?) use fetchzip and must use individual CDN
  # urls.
  srcs =
    if selected-fonts == { } then
      abort "fontshare-fonts: No fonts selected."
    else
      (lib.map fetchurl (
        lib.foldlAttrs (
          acc: _: font:
          acc ++ font.srcs
        ) [ ] selected-fonts
      ));

  sourceRoot = ".";

  dontBuild = true;
  unpackCmd = "cp $curSrc $(basename $curSrc | cut -d'-' -f2-)";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype

    cp *.ttf $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = {
    description = "Font files available from Fontshare.";
    longDescription = ''
      Licensing depends on which fonts are selected. By default, all
      fonts are selected and thus unfree fonts are included. This
      package's metadata is configured such that selecting only free
      fonts will **not** require `allowUnfree = true`. Refer to the
      Fontshare website for licensing details.

      To select only certain fonts, use overrides such as:
      ```
      fontshare-fonts.override {
        fonts = ["Switzer" "Bespoke Serif"];
      }
      ```
      Note that the name must be what is provided on the Fontshare
      website, with proper capitalization and whitespace.

      To select only free fonts, use `fonts = "free"`.
    '';
    homepage = "https://fontshare.com/";
    license = licenses;
    platforms = lib.platforms.all;
    hydraPlatforms = [ ];
    maintainers = with lib.maintainers; [ thepuzzlemaker ];
  };
}
