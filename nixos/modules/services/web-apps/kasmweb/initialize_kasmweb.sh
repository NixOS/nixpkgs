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


docker network inspect kasm_default_network >/dev/null || docker network create kasm_default_network --subnet @networkSubnet@
if docker volume inspect kasmweb_db >/dev/null; then
    source @datastorePath@/ids.env
    echo 'echo "skipping database init"' > @datastorePath@/init_seeds.sh
    echo 'while true; do sleep 10 ; done' >> @datastorePath@/init_seeds.sh
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

    docker volume create kasmweb_db
    rm @datastorePath@/.done_initing_data
    cat >@datastorePath@/init_seeds.sh <<EOF
#!/bin/bash
if [ ! -e /opt/kasm/current/.done_initing_data ]; then
  sleep 4
  /usr/bin/kasm_server.so --initialize-database --cfg \
    /opt/kasm/current/conf/app/api.app.config.yaml \
    --populate-production \
    --seed-file \
    /opt/kasm/current/conf/database/seed_data/default_properties.yaml \
    2>&1 | grep -v UserWarning
  /usr/bin/kasm_server.so --cfg \
    /opt/kasm/current/conf/app/api.app.config.yaml \
    --populate-production \
    --seed-file \
    /opt/kasm/current/conf/database/seed_data/default_agents.yaml \
    2>&1 | grep -v UserWarning
  /usr/bin/kasm_server.so --cfg \
    /opt/kasm/current/conf/app/api.app.config.yaml \
    --populate-production \
    --seed-file \
    /opt/kasm/current/conf/database/seed_data/default_connection_proxies.yaml \
    2>&1 | grep -v UserWarning
  /usr/bin/kasm_server.so --cfg \
    /opt/kasm/current/conf/app/api.app.config.yaml \
    --populate-production \
    --seed-file \
    /opt/kasm/current/conf/database/seed_data/default_images_amd64.yaml \
    2>&1 | grep -v UserWarning
  touch /opt/kasm/current/.done_initing_data
  while true; do sleep 10 ; done
else
 echo "skipping database init"
  while true; do sleep 10 ; done
fi
EOF
fi

chmod +x @datastorePath@/init_seeds.sh
chmod a+w @datastorePath@/init_seeds.sh

if [ -e @sslCertificate@ ]; then
    cp @sslCertificate@ @datastorePath@/certs/kasm_nginx.crt
    cp @sslCertificateKey@ @datastorePath@/certs/kasm_nginx.key
fi

sed -i -e "s/username.*/username: @postgresUser@/g" \
    -e "s/password.*/password: @postgresPassword@/g" \
    -e "s/host.*db/host: kasm_db/g" \
    -e "s/ssl: true/ssl: false/g" \
    -e "s/redisPassword.*/redisPassword: @redisPassword@/g" \
    -e "s/server_hostname.*/server_hostname: kasm_api/g" \
    -e "s/server_id.*/server_id: $API_SERVER_ID/g" \
    -e "s/manager_id.*/manager_id: $MANAGER_ID/g" \
    -e "s/share_id.*/share_id: $SHARE_ID/g" \
    @datastorePath@/conf/app/api.app.config.yaml

sed -i -e "s/ token:.*/ token: \"@defaultManagerToken@\"/g" \
    -e "s/hostnames: \['proxy.*/hostnames: \['kasm_proxy'\]/g" \
    -e "s/server_id.*/server_id: $SERVER_ID/g" \
    @datastorePath@/conf/app/agent.app.config.yaml


sed -i -e "s/password: admin.*/password: \"@defaultAdminPassword@\"/g" \
    -e "s/password: user.*/password: \"@defaultUserPassword@\"/g" \
    -e "s/default-manager-token/@defaultManagerToken@/g" \
    -e "s/default-registration-token/@defaultRegistrationToken@/g" \
    -e "s/upstream_auth_address:.*/upstream_auth_address: 'proxy'/g" \
    @datastorePath@/conf/database/seed_data/default_properties.yaml

sed -i -e "s/GUACTOKEN/@defaultGuacToken@/g" \
    -e "s/APIHOSTNAME/proxy/g" \
    @datastorePath@/conf/app/kasmguac.app.config.yaml

sed -i -e "s/GUACTOKEN/@defaultGuacToken@/g" \
    -e "s/APIHOSTNAME/proxy/g" \
    @datastorePath@/conf/database/seed_data/default_connection_proxies.yaml

sed -i "s/00000000-0000-0000-0000-000000000000/$SERVER_ID/g" \
    @datastorePath@/conf/database/seed_data/default_agents.yaml

