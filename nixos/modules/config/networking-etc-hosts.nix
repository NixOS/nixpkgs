{ config, lib, ... }:

with lib;

let
  unhex       = { "0"=0; "1"=1; "2"=2; "3"=3; "4"=4; "5"=5; "6"=6; "7"=7; "8"=8; "9"=9; a=10; b=11; c=12; d=13; e=14; f=15; A=10; B=11; C=12; D=13; E=14; F=15; };
  hex         = "0123456789abcdef";
  fromHex     = s: errormessage: foldl (a: b: a*16 + unhex.${b} or (throw errormessage)) 0 (stringToCharacters s);
  toHexFull   = i: "${substring (bitAnd 15 (i / 4096)) 1 hex}${substring (bitAnd 15 (i / 256)) 1 hex}${substring (bitAnd 15 (i / 16)) 1 hex}${substring (bitAnd 15 i) 1 hex}";
  toHexCompact= i:      if i >= 4096 then toHexFull i
                   else if i >= 256  then substring 1 3 (toHexFull i)
                   else if i >= 16   then substring 2 2 (toHexFull i)
                   else                   substring 3 1 (toHexFull i);

  normalizeIP = ip:
                if hasInfix ":" ip then
                  # normalize ipv6
                  concatMapStringsSep ":" (x: let
                                                i = fromHex x "invalid ip ${ip}";
                                              in
                                                if 0 <= i && i <= 65535 then toHexFull i else throw "invalid ip ${ip}"
                                          ) (
                    let
                      parts1 = filter (x: x != "") (splitString ":"  ip);
                      parts2 =                      splitString "::" ip;
                    in
                      if length parts2 == 1 && length parts1 == 8 then
                        parts1
                      else if length parts2 == 2 && length parts1 < 8 then
                        let
                          left  = filter (x: x != "") (splitString ":" (elemAt parts2 0));
                          right = filter (x: x != "") (splitString ":" (elemAt parts2 1));
                        in
                          left ++ (map (_: "0") (range (length parts1) 7)) ++ right
                      else
                        throw "invalid ip ${ip}"
                  )
                else
                  # normalize ipv4
                  concatMapStringsSep "." (x: let
                                                i = toInt x;
                                              in
                                                if 0 <= i && i <= 255 then toString i else throw "invalid ip ${ip}"
                                          ) (
                    let
                      parts = splitString "." ip;
                    in
                           if length parts == 2 then [ (elemAt parts 0) 0                0 (elemAt parts 1) ]
                      else if length parts == 3 then [ (elemAt parts 0) (elemAt parts 1) 0 (elemAt parts 2) ]
                      else if length parts == 4 then parts
                      else throw "invalid ip ${ip}"
                  );

  compactIP   = ip:
                if hasInfix ":" ip then
                  # compact IPv6 assuming it is already normalized
                  let
                    c = concatMapStringsSep ":" (x: toHexCompact (fromHex x "invalid ip ${ip}")) (splitString ":" ip);
                  in
                    if c == "0:0:0:0:0:0:0:0" then "::"
                    else if hasSuffix  ":0:0:0:0:0:0:0" c then   "${removeSuffix  ":0:0:0:0:0:0:0"        c}::"
                    else if hasPrefix "0:0:0:0:0:0:0:"  c then "::${removePrefix "0:0:0:0:0:0:0:"         c}"
                    else if hasSuffix    ":0:0:0:0:0:0" c then   "${removeSuffix    ":0:0:0:0:0:0"        c}::"
                    else if hasPrefix "0:0:0:0:0:0:"    c then "::${removePrefix "0:0:0:0:0:0:"           c}"
                    else if hasInfix   ":0:0:0:0:0:0:"  c then      replaceStrings [":0:0:0:0:0:0:"] ["::"] c
                    else if hasSuffix      ":0:0:0:0:0" c then   "${removeSuffix      ":0:0:0:0:0"        c}::"
                    else if hasPrefix "0:0:0:0:0:"      c then "::${removePrefix "0:0:0:0:0:"             c}"
                    else if hasInfix   ":0:0:0:0:0:"    c then      replaceStrings [":0:0:0:0:0:"]   ["::"] c
                    else if hasSuffix        ":0:0:0:0" c then   "${removeSuffix        ":0:0:0:0"        c}::"
                    else if hasPrefix "0:0:0:0:"        c then "::${removePrefix "0:0:0:0:"               c}"
                    else if hasInfix   ":0:0:0:0:"      c then      replaceStrings [":0:0:0:0:"]     ["::"] c
                    else if hasSuffix          ":0:0:0" c then   "${removeSuffix          ":0:0:0"        c}::"
                    else if hasPrefix "0:0:0:"          c then "::${removePrefix "0:0:0:"                 c}"
                    else if hasInfix   ":0:0:0:"        c then      replaceStrings [":0:0:0:"]       ["::"] c
                    else if hasSuffix            ":0:0" c then   "${removeSuffix            ":0:0"        c}::"
                    else if hasPrefix "0:0:"            c then "::${removePrefix "0:0:"                   c}"
                   #else if hasInfix   ":0:0:"          c then      replaceStrings [":0:0:"]         ["::"] c  # don`t, this can be found >1 times
                   #else if hasInfix   ":0:"            c then      replaceStrings [":0:"]           ["::"] c  # don`t, this can be found >1 times
                    else c
                else
                  # nothing to do with IPv4
                  ip;

                                                                                          # https://en.wikipedia.org/wiki/Reserved_IP_addresses
  isPrivateIPv4 = ip: builtins.match ( "(0\\."                                            # 0.0.0.0/8
                                     + "|10\\."                                           # 10.0.0.0/8
                                     + "|100\\.(6[4-9]|[789][0-9]|1[01][0-9]|12[0-7])\\." # 100.64.0.0/10
                                     + "|169\\.254\\."                                    # 169.254.0.0/16
                                     + "|172\\.(1[6-9]|2[0-9]|3[01])\\."                  # 172.16.0.0/12
                                     + "|192\\.0\\.[02]\\."                               # 192.0.0.0/24 192.0.2.0/24
                                     + "|192\\.88\\.99\\."                                # 192.88.99.0/24
                                     + "|192\\.168\\."                                    # 192.168.0.0/16
                                     + "|198\\.1[89]\\."                                  # 198.18.0.0/15
                                     + "|198\\.51\\.100\\."                               # 198.51.100.0/24
                                     + "|203\\.0\\.113\\."                                # 203.0.113.0/24
                                     + "|2(2[4-9]|[34][0-9]|5[0-5])\\."                   # 224.0.0.0/4 240.0.0.0/4
                                     + ").+"
                                     ) ip != null;
  isPrivateIPv6 = ip: builtins.match "f[cdef]..:.+" ip != null; # assume IPv6 is normalized (lowcased)
in
{
  config = {
    environment.etc."hosts".text = (
      let
        set         = filterAttrs (_: v: v != []) config.networking.hosts;
        normSet     = groupBy normalizeIP (attrNames set); # { "0000:0000:0000:0000:0000:0000:0000:000f" = ["::f" "::F" "0::f"]; "10.0.0.4" = ["10.4" "10.0.4"]; ... }
        oneToString = normip: "${compactIP normip} ${concatStringsSep " " (unique (concatMap (ip: set.${ip}) normSet.${normip}))}";
        ipv6s       = partition (hasInfix  ":"                                    ) (attrNames normSet);
        local4s     = partition (hasPrefix "127."                                 ) ipv6s.wrong;
        private4s   = partition isPrivateIPv4                                       local4s.wrong;
        local6s     = partition (x: x == "0000:0000:0000:0000:0000:0000:0000:0001") ipv6s.right;
        private6s   = partition isPrivateIPv6                                       local6s.wrong;
      in ''
        # LOCALHOST
        ${ concatMapStringsSep "\n" oneToString (naturalSort local4s.right) }
        ${ concatMapStringsSep "\n" oneToString local6s.right }
        # LAN IPv4
        ${ concatMapStringsSep "\n" oneToString (naturalSort private4s.right) }
        # WAN IPv4
        ${ concatMapStringsSep "\n" oneToString (naturalSort private4s.wrong) }
        # LAN IPv6
        ${ concatMapStringsSep "\n" oneToString private6s.right }
        # WAN IPv6
        ${ concatMapStringsSep "\n" oneToString private6s.wrong }
        # EXTRA HOSTS
        ${config.networking.extraHosts}
      '');
  };
}
