{
  stdenv,
  fetchFromGitHub,
  mono,
  gtk2,
  msbuild,
  iconv,
  lib,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "nbtexplorer";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "jaquadro";
    repo = "NBTExplorer";
    rev = "v${version}-win";
    sha256 = "uOoELun0keFYN1N2/a1IkCP1AZQvfDLiUdrLxxrhE/A=";
    fetchSubmodules = true;
  };

  buildInputs = [gtk2];
  nativeBuildInputs = [mono msbuild makeWrapper iconv];

  preBuild = ''
    for f in NBTExplorer/Vendor/Be.Windows.Forms.HexBox/*.cs; do
      iconv -f WINDOWS-1252 -t UTF-8 "$f" > "$f.tmp" && mv "$f.tmp" "$f"
    done
  '';

  buildPhase = ''
    msbuild NBTExplorer/NBTExplorer.csproj \
      /p:Configuration=Release \
      /p:UseSharedCompilation=false \
      /p:CodePage=65001 \
      /p:TargetFrameworkVersion=v4.5
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp NBTExplorer/bin/Release/NBTExplorer.exe $out/bin/
    cp NBTExplorer/bin/Release/*.dll $out/bin/

    makeWrapper ${mono}/bin/mono $out/bin/nbtexplorer \
      --add-flags "$out/bin/NBTExplorer.exe" \
      --prefix LD_LIBRARY_PATH : "${gtk2}/lib"
  '';

  meta = {
    description = "NBT editor for Minecraft game data";
    homepage = "https://github.com/jaquadro/NBTExplorer";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ peritia ];
  };
}
