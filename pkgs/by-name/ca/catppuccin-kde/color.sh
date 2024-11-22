echo $FLAVOUR $ACCENT $WINDECSTYLE

FLAVOURNAME=${FLAVOUR^}
ACCENTNAME=${ACCENT^}
WINDECSTYLENAME=${WINDECSTYLE^}

if [[ $FLAVOURNAME == "Mocha" ]]; then
    FLAVOUR="1";
elif [[ $FLAVOURNAME == "Macchiato" ]]; then
    FLAVOUR="2";
elif [[ $FLAVOURNAME == "Frappe" ]]; then
    FLAVOUR="3";
elif [[ $FLAVOURNAME == "Latte" ]]; then
    FLAVOUR="4";
fi
if [[ $FLAVOURNAME == "Mocha" ]]; then
    FLAVOUR="1";
elif [[ $FLAVOURNAME == "Macchiato" ]]; then
    FLAVOUR="2";
elif [[ $FLAVOURNAME == "Frappe" ]]; then
    FLAVOUR="3";
elif [[ $FLAVOURNAME == "Latte" ]]; then
    FLAVOUR="4";
fi


if [[ $ACCENTNAME == "Rosewater" ]]; then
    ACCENT="1"
elif [[ $ACCENTNAME == "Flamingo" ]]; then
    ACCENT="2"
elif [[ $ACCENTNAME == "Pink" ]]; then
    ACCENT="3"
elif [[ $ACCENTNAME == "Mauve" ]]; then
    ACCENT="4"
elif [[ $ACCENTNAME == "Red" ]]; then
    ACCENT="5"
elif [[ $ACCENTNAME == "Maroon" ]]; then
    ACCENT="6"
elif [[ $ACCENTNAME == "Peach" ]]; then
    ACCENT="7"
elif [[ $ACCENTNAME == "Yellow" ]]; then
    ACCENT="8"
elif [[ $ACCENTNAME == "Green" ]]; then
    ACCENT="9"
elif [[ $ACCENTNAME == "Teal" ]]; then
    ACCENT="10"
elif [[ $ACCENTNAME == "Sky" ]]; then
    ACCENT="11"
elif [[ $ACCENTNAME == "Sapphire" ]]; then
    ACCENT="12"
elif [[ $ACCENTNAME == "Blue" ]]; then
    ACCENT="13"
elif [[ $ACCENTNAME == "Lavender" ]]; then
    ACCENT="14"
fi

if [[ $WINDECSTYLENAME == "Modern" ]]; then
    WINDECSTYLE=1
elif [[ $WINDECSTYLENAME == "Classic" ]]; then
    WINDECSTYLE=2
fi
