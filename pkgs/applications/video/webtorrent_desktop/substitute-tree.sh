
substituteTree_ensureDirectory () {
    local out=$1
    local dir=$2
    local target
    if [ "." == "$dir" ]
    then target=$out
    else target=$out/$dir
    fi
    local ltarget=$(readlink -vm "$target")
    
    if [ "." != "$dir" ]
    then substituteTree_ensureDirectory "$out" "$(dirname "$dir")"
    fi

    if [ -d "$target" ]
    then if [ -L "$target" ]
         then rm "$target"
              mkdir "$target"
              for entry in "$ltarget"/*
              do ln -s "$entry" "$target"
              done
         else return 0
         fi
    elif [ -e "$target" ]
    then echo >&2 "$target -> $ltarget is already a $(file -b "$ltarget"), cannot create directory"
         return 1
    fi
}

substituteTree_ensureFile () {
    local out=$1
    local file=$2
    local target=$out/$file
    local ltarget=$(readlink -vm "$target")
    if [ -d "$ltarget" ]
    then echo >&2 "$target -> $ltarget is already a $(file -b "$ltarget"), cannot create file"
         return 1
    fi
    substituteTree_ensureDirectory "$out" "$(dirname "$file")"
}

substituteTree_link () {
    local out=$1
    local source=$2
    local tgt=$3
    local target
    if [ "." == "$tgt" ]
    then target=$out
    else target=$out/$tgt
    fi
    local lsource=$(readlink -ve "$source")
    local ltarget=$(readlink -vm "$target")

    if [ -d "$lsource" ]
    then
        substituteTree_ensureDirectory "$out" "$tgt"
        if [ ! -e "$target" ]
        then ln -s "$lsource" "$target"
        else for entry in "$lsource"/*
             do substituteTree_link "$out" "$entry" "$target/$(basename $entry)"
             done
        fi
    else
        substituteTree_ensureFile "$out" "$tgt"
        rm -f "$target"
        ln -s "$lsource" "$target"
    fi
}

substituteTree_run () {
    local out=$1
    local op=$2
    shift 2
    case $op in
        --link)
            substituteTree_link "$out" "$1" "$2"
            ;;
        --substituteAll)
            substituteTree_ensureFile "$out" "$2"
            mkdir -p "$(dirname "$out/$2")"
            substituteAll "$1" "$out/$2"
            ;;
        --substituteInPlace)
            local file=$1
            shift
            substituteTree_ensureFile "$out" "$file"
            local content
            consumeEntire content < "$out/$file"
            rm -f "$out/$file"
            substituteStream content "file '$out/$file'" "$@" > "$out/$file"
            ;;
    esac
}

substituteTree () {
    local out=$1
    local op=$2
    shift 2
    local -a op_args=()
    while (( "$#" ))
    do
        case $1 in
            --link | --substituteAll | --substituteInPlace )
                # echo "PARGS $(printf "'%q' " "${op_args[@]}")"
                substituteTree_run "$out" "$op" "${op_args[@]}"
                op="$1"
                op_args=()
                ;;
            *)
                op_args=("${op_args[@]}" "$1")
                ;;
        esac
        shift
    done
    substituteTree_run "$out" "$op" "${op_args[@]}"
}
