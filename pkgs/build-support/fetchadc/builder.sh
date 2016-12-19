source $stdenv/setup

loginpage=`curl --insecure -s -L -b cookies.txt "$url"`

[[ $loginpage =~ form[^\>]+action=\"([^\"]+)\" ]] && loginurl=${BASH_REMATCH[1]}

curl  --insecure -s --output "$out" -L -b cookies.txt --data "appleId=${adc_user}&accountPassword=${adc_pass}" "https://idmsa.apple.com/IDMSWebAuth/${loginurl}"
