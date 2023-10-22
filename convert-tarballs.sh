#!/usr/bin/env bash

versionSrcFile="./new-tarballs.nix"
rm $versionSrcFile
urls="$(cat ./pkgs/servers/x11/xorg/tarballs.list)"

echo '{ fetchurl, fetchFromGitLab }:' > $versionSrcFile
echo '{' >> $versionSrcFile

for url in $urls; do
    #echo $url
    if [[ $url =~ gitlab ]]; then
        echo "$url" >> $versionSrcFile

        if [[ $url =~ xf86-video-ati ]]; then
                cat >> $versionSrcFile << EOF
  xf86-video-ati = {
    pname = "xf86-video-ati";
    version = "$version";
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      group = "xorg";
      owner = "driver";
      repo = "xf86-video-ati";
      rev = "5eba006e4129e8015b822f9e1d2f1e613e252cda";
      hash = "sha256-dlJi2YUK/9qrkwfAy4Uds4Z4a82v6xP2RlCOsEHnidg=";
    };
  };
EOF
        elif [[ $url =~ xf86-video-nouveau ]]; then
                cat >> $versionSrcFile << EOF
  xf86-video-nouveau = {
    pname = "xf86-video-nouveau";
    version = "$version";
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      group = "xorg";
      owner = "driver";
      repo = "xf86-video-nouveau";
      rev = "3ee7cbca8f9144a3bb5be7f71ce70558f548d268";
      hash = "sha256-WmGjI/svtTngdPQgqSfxeR3Xpe02o3uB2Y9k19wqJBE=";
    };
  };
EOF
        fi
        continue
    fi

    if true; then
    #if [[ $url =~ lib ]]; then
        bname="$(basename -s ".tgz" "$(basename -s ".tar.gz" "$(basename -s ".tar.bz2" "$(basename -s ".tar.xz" "$url")")")")"
        bnameWithoutVersion=$(rev <<< "$bname" | cut -d"-" -f2- | rev)
        filename="$bnameWithoutVersion-$bname"
        group="$(basename "$(dirname "$url")")"
        newname="$bnameWithoutVersion"
        tagname="$bname"
        owner="xorg"
        version=$(rev <<< "$bname" | cut -d"-" -f1 | rev)

        if [[ $bnameWithoutVersion == "x11perf" ]]; then
            group="test"
        fi


        if [[ $url =~ /font/ ]]; then
            # the repos don't have font- prefixes
            newname="${bnameWithoutVersion#font-}"
        fi

        if [[ $bname =~ xbitmaps|xcursor-themes ]]; then
            newname="${bnameWithoutVersion#x}"
            # cursor-themes -> cursors
            newname="${newname/%-themes/s}"
        fi

        if [[ $bname =~ xtrans ]]; then
            newname="libxtrans"
        fi

        if [[ $bnameWithoutVersion == "xcb-proto" ]]; then
            newname="xcbproto"
        fi

        if [[ $bnameWithoutVersion == "util-macros" ]]; then
            newname="macros"
        fi

        if [[ $bname =~ vboxvideo ]]; then
            newname="xf86-video-vbox"
            filename="xf86-video-vbox-xf86-video-vboxvideo-${version}"
        fi

        if [[ $bnameWithoutVersion == "xorg-server" ]]; then
            newname="xserver"
            group=""
            filename="$newname-$bname"
        fi

        if [[ $bnameWithoutVersion == "xkeyboard-config" ]]; then
            owner="xkeyboard-config"
            group=""
        fi

        if [[ $bnameWithoutVersion == "xf86-video-intel" ]]; then
            tagname="$version"
        fi

        if [[ $bnameWithoutVersion =~ "xcb-util-" ]]; then
            newname="${bnameWithoutVersion/#xcb-util/libxcb}"
            filename="$newname-$bname"
        fi

        if [[ $bnameWithoutVersion == "xcb-util" ]]; then
            newname="libxcb-util"
            filename="$newname-$bname"
        fi

        if [[ $bnameWithoutVersion == "xcb-util-renderutil" ]]; then
            newname="libxcb-render-util"
            filename="$newname-$bname"
        fi

        if [[ $bnameWithoutVersion == "xcb-util" ]]; then
            newname="libxcb-util"
            filename="$newname-$bname"
        fi

        if [[ $bnameWithoutVersion == "xorg-cf-files" ]]; then
            newname="cf"
        fi

        if [[ $bnameWithoutVersion == "libpthread-stubs" ]]; then
            newname="pthread-stubs"
            #filename="$newname-$bname"
            # we're still at 0.4
            # https://gitlab.freedesktop.org/xorg/lib/pthread-stubs/-/archive/0.4/pthread-stubs-0.4.tar.bz2
            # vs 0.5 url
            # https://gitlab.freedesktop.org/xorg/lib/pthread-stubs/-/archive/libpthread-stubs-0.5/pthread-stubs-libpthread-stubs-0.5.tar.bz2
            # so remove the below if updated
            #filename="$newname-$version"
            #tagname="$version"
        fi

        if [[ $group == "xcb" ]]; then
            group="lib"
        fi

        groupforurl="${group:+/$group}"
        giturl="https://gitlab.freedesktop.org/$owner$groupforurl/$newname"

        echo $giturl

        echo -n "$bname: "
        # GIT_ASKPASS is so git does not prompt for user and pass when the repo doesn't exist
        if lsremote="$(GIT_ASKPASS="echo" git ls-remote "${giturl}.git" 2>/dev/null)"; then
            echo -n "found "
            newurl="${giturl}/-/archive/$tagname/$filename.tar.bz2"
            echo "$newurl"

            if wget="$(wget --no-clobber --quiet "$newurl")"; then
                hash=$(nix-prefetch-url "https://gitlab.freedesktop.org/api/v4/projects/${owner}%2F${group}%2F${newname}/repository/archive.tar.gz?sha=refs%2Ftags%2F${bname}" --name source --unpack --type sha256 | xargs nix hash to-sri --type sha256)
                cat >> $versionSrcFile << EOF
  $bnameWithoutVersion = {
    pname = "$bnameWithoutVersion";
    version = "$version";
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      group = "$owner";
      owner = "$group";
      repo = "$newname";
      rev = "refs/tags/$bname";
      hash = "$hash";
    };
  };
EOF
            else
                echo "gitlab source for $bname found but the new url was wrong"
                echo "@PLACEHOLDER WRONG URL $bname@" >> $versionSrcFile
            fi
        else
            echo "not found"
                hash=$(nix-prefetch-url "$url" --name source --unpack --type sha256 | xargs nix hash to-sri --type sha256)
                cat >> $versionSrcFile << EOF
  $bnameWithoutVersion = {
    pname = "$bnameWithoutVersion";
    version = "$version";
    src = fetchurl {
      url = "$url";
      hash = "$hash";
    };
  };
EOF
        fi
    fi
done
echo '}' >> $versionSrcFile
