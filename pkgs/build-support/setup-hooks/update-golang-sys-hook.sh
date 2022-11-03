preConfigureHooks+=(updateGolangSys)

updateGolangSys() {
    sed -i '/golang.org\/x\/sys/d' go.mod
    cat >>go.mod <<EOF
require (
    golang.org/x/sys v0.0.0-20220731174439-a90be440212d // indirect
)
EOF
    cat >>go.sum <<EOF
golang.org/x/sys v0.0.0-20220731174439-a90be440212d h1:Sv5ogFZatcgIMMtBSTTAgMYsicp25MXBubjXNDKwm80=
golang.org/x/sys v0.0.0-20220731174439-a90be440212d/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
EOF
}
