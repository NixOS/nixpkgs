use data_encoding::BASE64;
use digest::{Digest, Update};
use serde::{Deserialize, Serialize};
use sha1::Sha1;
use sha2::{Sha256, Sha512};
use std::{
    fmt::Write as FmtWrite,
    fs::{self, File},
    io::Write,
    path::PathBuf,
};
use url::Url;

#[allow(clippy::struct_field_names)]
#[derive(Serialize, Deserialize)]
pub(super) struct Key {
    pub(super) key: String,
    pub(super) integrity: String,
    pub(super) time: u8,
    pub(super) size: usize,
    pub(super) metadata: Metadata,
}

#[derive(Serialize, Deserialize)]
pub(super) struct Metadata {
    pub(super) url: Url,
    pub(super) options: Options,
}

#[derive(Serialize, Deserialize)]
pub(super) struct Options {
    pub(super) compress: bool,
}

pub struct Cache(PathBuf);

fn push_hash_segments(path: &mut PathBuf, hash: &str) {
    path.push(&hash[0..2]);
    path.push(&hash[2..4]);
    path.push(&hash[4..]);
}

impl Cache {
    pub fn new(path: PathBuf) -> Cache {
        Cache(path)
    }

    pub fn init(&self) -> anyhow::Result<()> {
        fs::create_dir_all(self.0.join("content-v2"))?;
        fs::create_dir_all(self.0.join("index-v5"))?;

        Ok(())
    }

    pub fn put(
        &self,
        key: String,
        url: Url,
        data: &[u8],
        integrity: Option<String>,
    ) -> anyhow::Result<()> {
        let (algo, hash, integrity) = if let Some(integrity) = integrity {
            let (algo, hash) = integrity
                .split_once('-')
                .expect("hash should be SRI format");

            (algo.to_string(), BASE64.decode(hash.as_bytes())?, integrity)
        } else {
            let hash = Sha512::new().chain(data).finalize();

            (
                String::from("sha512"),
                hash.to_vec(),
                format!("sha512-{}", BASE64.encode(&hash)),
            )
        };

        let content_path = {
            let mut p = self.0.join("content-v2");

            p.push(algo);

            push_hash_segments(
                &mut p,
                &hash.into_iter().fold(String::new(), |mut out, n| {
                    let _ = write!(out, "{n:02x}");
                    out
                }),
            );

            p
        };

        fs::create_dir_all(content_path.parent().unwrap())?;

        fs::write(content_path, data)?;

        let index_path = {
            let mut p = self.0.join("index-v5");

            push_hash_segments(
                &mut p,
                &format!("{:x}", Sha256::new().chain(&key).finalize()),
            );

            p
        };

        fs::create_dir_all(index_path.parent().unwrap())?;

        let data = serde_json::to_string(&Key {
            key,
            integrity,
            time: 0,
            size: data.len(),
            metadata: Metadata {
                url,
                options: Options { compress: true },
            },
        })?;

        let mut file = File::options().append(true).create(true).open(index_path)?;

        write!(file, "{:x}\t{data}", Sha1::new().chain(&data).finalize())?;

        Ok(())
    }
}
