set -euo pipefail

smokeDir=$(mktemp -d)
trap 'rm -rf "$smokeDir"' EXIT
cd "$smokeDir"
unset KUNA_ROOT SLEIGHHOME

kuna --version

cat > sample.c <<'EOF'
/* Keep the fixture's symbol name identical on ELF and Mach-O. */
int scale(int) __asm__("scale");
__attribute__((noinline)) int scale(int n) { return n * 3 + 1; }
int main(void) { return scale(19) != 58; }
EOF

cat > roundtrip.c <<'EOF'
int scale(int);
int main(void) {
    return !(scale(-7) == -20 && scale(0) == 1 && scale(19) == 58);
}
EOF

"$CC" -O1 -g0 sample.c -o sample
kuna decompile-project sample --functions scale -o exported
"$CC" -O1 exported/sample.c roundtrip.c -o roundtrip
./roundtrip
