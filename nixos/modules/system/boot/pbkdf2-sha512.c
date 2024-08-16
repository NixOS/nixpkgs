#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <openssl/evp.h>

void hextorb(uint8_t* hex, uint8_t* rb)
{
	while(sscanf(hex, "%2x", rb) == 1)
	{
		hex += 2;
		rb += 1;
	}
	*rb = '\0';
}

int main(int argc, char** argv)
{
	uint8_t k_user[2048];
	uint8_t salt[2048];
	uint8_t key[4096];

	uint32_t key_length = atoi(argv[1]);
	uint32_t iteration_count = atoi(argv[2]);

	hextorb(argv[3], salt);
	uint32_t salt_length = strlen(argv[3]) / 2;

	fgets(k_user, 2048, stdin);
	uint32_t k_user_length = strlen(k_user);
	if(k_user[k_user_length - 1] == '\n') {
			k_user[k_user_length - 1] = '\0';
	}

	PKCS5_PBKDF2_HMAC(k_user, k_user_length, salt, salt_length, iteration_count, EVP_sha512(), key_length, key);
	fwrite(key, 1, key_length, stdout);

	return 0;
}
