#! @runtimeShell@
export PATH=@binPath@:$PATH

mkdir -p @datastorePath@/log
chmod -R a+rw @datastorePath@

ln -sf @kasmweb@/bin @datastorePath@
rm -r @datastorePath@/conf
cp -r @kasmweb@/conf @datastorePath@
mkdir -p @datastorePath@/conf/nginx/containers.d
chmod -R a+rw @datastorePath@/conf
ln -sf @kasmweb@/www @datastorePath@

cat >@datastorePath@/init_seeds.sh <<EOF
#!/bin/bash
if [ ! -e /opt/kasm/current/.done_initing_data ]; then
  while true; do
      sleep 15;
      /usr/bin/kasm_server.so --initialize-database --cfg \
        /opt/kasm/current/conf/app/api.app.config.yaml \
        --seed-file \
        /opt/kasm/current/conf/database/seed_data/default_properties.yaml \
        --populate-production \
        && break
  done  && /usr/bin/kasm_server.so --cfg \
    /opt/kasm/current/conf/app/api.app.config.yaml \
    --populate-production \
    --seed-file \
    /opt/kasm/current/conf/database/seed_data/default_agents.yaml \
  && /usr/bin/kasm_server.so --cfg \
    /opt/kasm/current/conf/app/api.app.config.yaml \
    --populate-production \
    --seed-file \
    /opt/kasm/current/conf/database/seed_data/default_images_amd64.yaml \
  && touch /opt/kasm/current/.done_initing_data

  while true; do sleep 10 ; done
else
 echo "skipping database init"
  while true; do sleep 10 ; done
fi
EOF

docker network inspect kasm_default_network >/dev/null || docker network create kasm_default_network --subnet @networkSubnet@
if [ -e @datastorePath@/ids.env ]; then
    source @datastorePath@/ids.env
else
    API_SERVER_ID=$(cat /proc/sys/kernel/random/uuid)
    MANAGER_ID=$(cat /proc/sys/kernel/random/uuid)
    SHARE_ID=$(cat /proc/sys/kernel/random/uuid)
    SERVER_ID=$(cat /proc/sys/kernel/random/uuid)
    echo "export API_SERVER_ID=$API_SERVER_ID" > @datastorePath@/ids.env
    echo "export MANAGER_ID=$MANAGER_ID" >> @datastorePath@/ids.env
    echo "export SHARE_ID=$SHARE_ID" >> @datastorePath@/ids.env
    echo "export SERVER_ID=$SERVER_ID" >> @datastorePath@/ids.env

    mkdir -p @datastorePath@/certs
    openssl req -x509 -nodes -days 1825 -newkey rsa:2048 -keyout @datastorePath@/certs/kasm_nginx.key -out @datastorePath@/certs/kasm_nginx.crt -subj "/C=US/ST=VA/L=None/O=None/OU=DoFu/CN=$(hostname)/emailAddress=none@none.none" 2> /dev/null

    mkdir -p @datastorePath@/file_mappings

    docker volume create kasmweb_db || true
    rm @datastorePath@/.done_initing_data
fi

chmod +x @datastorePath@/init_seeds.sh
chmod a+w @datastorePath@/init_seeds.sh

if [ -e @sslCertificate@ ]; then
    cp @sslCertificate@ @datastorePath@/certs/kasm_nginx.crt
    cp @sslCertificateKey@ @datastorePath@/certs/kasm_nginx.key
fi

yq -i '.server.zone_name = "'default'"' @datastorePath@/conf/app/api.app.config.yaml
yq -i '(.zones.[0]) .zone_name = "'default'"' @datastorePath@/conf/database/seed_data/default_properties.yaml

sed -i -e "s/username.*/username: @postgresUser@/g" \
    -e "s/password.*/password: @postgresPassword@/g" \
    -e "s/host.*db/host: kasm_db/g" \
    -e "s/ssl: true/ssl: false/g" \
    -e "s/redis_password.*/redis_password: @redisPassword@/g" \
    -e "s/server_hostname.*/server_hostname: kasm_api/g" \
    -e "s/server_id.*/server_id: $API_SERVER_ID/g" \
    -e "s/manager_id.*/manager_id: $MANAGER_ID/g" \
    -e "s/share_id.*/share_id: $SHARE_ID/g" \
    @datastorePath@/conf/app/api.app.config.yaml

sed -i -e "s/ token:.*/ token: \"@defaultManagerToken@\"/g" \
    -e "s/hostnames: \['proxy.*/hostnames: \['kasm_proxy'\]/g" \
    -e "s/server_id.*/server_id: $SERVER_ID/g" \
    @datastorePath@/conf/app/agent.app.config.yaml

# Generate a salt and hash for the desired passwords. Update the yaml
ADMIN_SALT=$(cat /proc/sys/kernel/random/uuid)
ADMIN_HASH=$(printf @defaultAdminPassword@${ADMIN_SALT} | sha256sum | cut -c-64)
USER_SALT=$(cat /proc/sys/kernel/random/uuid)
USER_HASH=$(printf @defaultUserPassword@${USER_SALT} | sha256sum | cut -c-64)

yq -i  '(.users.[] | select(.username=="admin@kasm.local") | .salt) = "'${ADMIN_SALT}'"'  @datastorePath@/conf/database/seed_data/default_properties.yaml
yq -i  '(.users.[] | select(.username=="admin@kasm.local") | .pw_hash) = "'${ADMIN_HASH}'"'  @datastorePath@/conf/database/seed_data/default_properties.yaml

yq -i  '(.users.[] | select(.username=="user@kasm.local") | .salt) = "'${USER_SALT}'"'  @datastorePath@/conf/database/seed_data/default_properties.yaml
yq -i  '(.users.[] | select(.username=="user@kasm.local") | .pw_hash) = "'${USER_HASH}'"'  @datastorePath@/conf/database/seed_data/default_properties.yaml

yq -i   '(.settings.[] | select(.name=="token") | select(.category == "manager")) .value = "'@defaultManagerToken@'"'   @datastorePath@/conf/database/seed_data/default_properties.yaml

yq -i   '(.settings.[] | select(.name=="registration_token") | select(.category == "auth")) .value = "'@defaultRegistrationToken@'"'   @datastorePath@/conf/database/seed_data/default_properties.yaml

sed -i -e "s/upstream_auth_address:.*/upstream_auth_address: 'proxy'/g" \
    @datastorePath@/conf/database/seed_data/default_properties.yaml

sed -i -e "s/GUACTOKEN/@defaultGuacToken@/g" \
    -e "s/APIHOSTNAME/proxy/g" \
    @datastorePath@/conf/app/kasmguac.app.config.yaml

sed -i "s/00000000-0000-0000-0000-000000000000/$SERVER_ID/g" \
    @datastorePath@/conf/database/seed_data/default_agents.yaml


while [ ! -e @datastorePath@/.done_initing_data ]; do
    sleep 10;
done

systemctl restart docker-kasm_proxy.service

