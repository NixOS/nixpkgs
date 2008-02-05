cat "$2" | while true; do
    read name || break
    read gid

    if ! curEnt=$(getent group "$name"); then
        echo "creating group $name..."
        groupadd --system \
            "$name" \
            ${gid:+--gid $gid}
    else
        #echo "updating group $name..."
        oldIFS="$IFS"; IFS=:; set -- $curEnt; IFS="$oldIFS"
        prevGid=$3
        if test -n "$gid" -a "$prevGid" != "$gid"; then
            groupmod "$name" --gid $gid
        fi
    fi
done


cat "$1" | while true; do
    read name || break
    read description
    read uid
    read group
    read extraGroups
    read home
    read shell
    read createHome

    if ! curEnt=$(getent passwd "$name"); then
        echo "creating user $name..."
        useradd --system \
            "$name" \
            --comment "$description" \
            ${uid:+--uid $uid} \
            --gid "$group" \
            --groups "$extraGroups" \
            --home "$home" \
            --shell "$shell" \
            ${createHome:+--create-home}
    else
        #echo "updating user $name..."
        oldIFS="$IFS"; IFS=:; set -- $curEnt; IFS="$oldIFS"
        prevUid=$3
        prevHome=$6
        # Don't change the UID if it's the same, otherwise usermod
        # will complain.
        if test "$prevUid" = "$uid"; then unset uid; fi
        # Don't change the home directory if it's the same to prevent
        # unnecessary warnings about logged in users.
        if test "$prevHome" = "$home"; then unset home; fi
        usermod \
            "$name" \
            --comment "$description" \
            ${uid:+--uid $uid} \
            --gid "$group" \
            --groups "$extraGroups" \
            ${home:+--home "$home"} \
            --shell "$shell"
    fi
done
