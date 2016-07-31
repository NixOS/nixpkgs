source $stdenv/setup

installPhase() {

	install -dm755 "${out}/share/geogebra"
	install "geogebra/"* -t "${out}/share/geogebra/"

#	install -Dm644 "${srcdir}/geogebra.desktop" "${pkgdir}/usr/share/applications/geogebra.desktop"
#	install -Dm644 "${srcdir}/geogebra-logo.svg" "${pkgdir}/usr/share/icons/hicolor/scalable/apps/geogebra.svg"
	mkdir "$out/bin"

	cat <<EOF > $out/bin/geogebra
#! $SHELL
export GG_PATH="$out/share/geogebra"
export JAVACMD="$jre/bin/java"

exec "\$GG_PATH/geogebra" "\$@"
EOF

	chmod +x "$out/bin/geogebra"
}
genericBuild
