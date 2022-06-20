{ lib
, fetchurl
, nerdfonts
}:
let
  font-droid = nerdfonts.override { fonts = [ "DroidSansMono" ]; };
  noto-rev = "a19de47f845dbd4c61b884c7ff90ce993555d05d";
  files =
    [{name = "NotoSans-Regular.ttf"; path="NotoSans"; hash = "sha256-PIOX7JZQ0O+FvQf8IJnakfqWTrsp2+OaOLlGF373nZs=";}
     {name = "NotoSans-Bold.ttf"; path="NotoSans"; hash = "sha256-Dz9gi6+NiEgPOZdHhxs3QUTq+eb4iA0ssZz8o6wlZpc=";}
     {name = "NotoSans-Italic.ttf"; path="NotoSans"; hash = "sha256-e9NTALuKb2qi9DFKAgLH/iy51QeKkDM5uLg0CnjzwxI=";}
     {name = "NotoSans-BoldItalic.ttf"; path="NotoSans"; hash = "sha256-65qbrVz3qIzDBlc7qeIjm5VEPihcyE9fAsOISMGwb5E=";}
     {name = "NotoSerif-Regular.ttf"; path="NotoSerif"; hash = "sha256-yPZpzrLJxgzPVRmLMF4IqZf/ynmjjMfutVHmQ8vmZQU=";}
     {name = "NotoSerif-Bold.ttf"; path="NotoSerif"; hash = "sha256-OyCGqGm83tKutEFvwoHO7J1s48BnVs2hn492NjYgTn0=";}
     {name = "NotoSerif-Italic.ttf"; path="NotoSerif"; hash = "sha256-Dqgda1T8iqXf8P1uvnz6Qx6ebPdHqNSqM1gfoKrM/+o=";}
     {name = "NotoSerif-BoldItalic.ttf"; path="NotoSerif"; hash = "sha256-T7hzcUW0pQPVSK9LUXr9/FMuRKlqwVN4JX6CV0EzTuw=";}
     {name = "NotoSansArabicUI-Regular.ttf"; path="NotoSansArabicUI"; hash = "sha256-bD2IHntzr/sjDSDne0SgvSp1yl7IdaT6AJea2lyYk1I=";}
     {name = "NotoSansArabicUI-Bold.ttf"; path="NotoSansArabicUI"; hash = "sha256-hNQH1vKll+8brsc5j/mPmHaYpm5dc00srqo9UJ6ECf0=";}
     {name = "NotoSansDevanagariUI-Regular.ttf"; path="NotoSansDevanagariUI"; hash = "sha256-fC6cKx7J0qpMFTOyRn/EFIRmZnQ1msJGK8bOsYXY6QA=";}
     {name = "NotoSansBengaliUI-Regular.ttf"; path="NotoSansBengaliUI"; hash = "sha256-+v5m3SVUYqKXiK6bdW28AZ/7TUPHT+PWCc4csUMmH0w=";}
    ];
  getFont = {name, path, hash}: fetchurl {
    url =  "https://github.com/googlefonts/noto-fonts/raw/${noto-rev}/hinted/ttf/${path}/${name}";
    sha256 = hash;
    passthru = {inherit name; };
  };
  noto-fonts-cjk = fetchurl {
    url =
      let
        version = "165c01b46ea533872e002e0785ff17e44f6d97d8";
      in
        "https://github.com/googlefonts/noto-cjk/raw/${version}/Sans/OTF/SimplifiedChinese/NotoSansCJKsc-Regular.otf";
    sha256 = "sha256-LHYlT2/Def3fzgp+hPtThbsTXT45kpT27rZoDQNlt0s=";
    passthru = {name = "NotoSansCJKsc-Regular.otf"; };
  };
  noto-fonts = map getFont files ++ [noto-fonts-cjk];
in
{
  installPhase = ''
    notoFonts=(${lib.concatStringsSep " " noto-fonts})
    notoFontsTargets=(${lib.concatStringsSep " " (map (x: x.name) noto-fonts)})
    for i in ''${!notoFonts[@]}; do
      file=''${notoFonts[$i]}
      target=''${notoFontsTargets[$i]}
      cp "$file" "$out/lib/koreader/fonts/noto/$target"
    done
    ln -s "${font-droid}/share/fonts/opentype/NerdFonts/Droid Sans Mono Nerd Font Complete Mono.otf" $out/lib/koreader/fonts/droid/DroidSansMono.ttf
    '';
}
