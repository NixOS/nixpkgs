# Pict-rs {#module-services-pict-rs}

pict-rs is a  a simple image hosting service.

## Quickstart {#module-services-pict-rs-quickstart}

the minimum to start pict-rs is

```nix
{
  services.pict-rs.enable = true;
}
```

this will start the http server on port 8080 by default.

## Usage {#module-services-pict-rs-usage}

pict-rs offers the following endpoints:

- `POST /image` for uploading an image. Uploaded content must be valid multipart/form-data with an
    image array located within the `images[]` key

    This endpoint returns the following JSON structure on success with a 201 Created status
    ```json
    {
        "files": [
            {
                "delete_token": "JFvFhqJA98",
                "file": "lkWZDRvugm.jpg"
            },
            {
                "delete_token": "kAYy9nk2WK",
                "file": "8qFS0QooAn.jpg"
            },
            {
                "delete_token": "OxRpM3sf0Y",
                "file": "1hJaYfGE01.jpg"
            }
        ],
        "msg": "ok"
    }
    ```
- `GET /image/download?url=...` Download an image from a remote server, returning the same JSON
    payload as the `POST` endpoint
- `GET /image/original/{file}` for getting a full-resolution image. `file` here is the `file` key from the
    `/image` endpoint's JSON
- `GET /image/details/original/{file}` for getting the details of a full-resolution image.
    The returned JSON is structured like so:
    ```json
    {
        "width": 800,
        "height": 537,
        "content_type": "image/webp",
        "created_at": [
            2020,
            345,
            67376,
            394363487
        ]
    }
    ```
- `GET /image/process.{ext}?src={file}&...` get a file with transformations applied.
    existing transformations include
    - `identity=true`: apply no changes
    - `blur={float}`: apply a gaussian blur to the file
    - `thumbnail={int}`: produce a thumbnail of the image fitting inside an `{int}` by `{int}`
        square using raw pixel sampling
    - `resize={int}`: produce a thumbnail of the image fitting inside an `{int}` by `{int}` square
        using a Lanczos2 filter. This is slower than sampling but looks a bit better in some cases
    - `crop={int-w}x{int-h}`: produce a cropped version of the image with an `{int-w}` by `{int-h}`
        aspect ratio. The resulting crop will be centered on the image. Either the width or height
        of the image will remain full-size, depending on the image's aspect ratio and the requested
        aspect ratio. For example, a 1600x900 image cropped with a 1x1 aspect ratio will become 900x900. A
        1600x1100 image cropped with a 16x9 aspect ratio will become 1600x900.

    Supported `ext` file extensions include `png`, `jpg`, and `webp`

    An example of usage could be
    ```
    GET /image/process.jpg?src=asdf.png&thumbnail=256&blur=3.0
    ```
    which would create a 256x256px JPEG thumbnail and blur it
- `GET /image/details/process.{ext}?src={file}&...` for getting the details of a processed image.
    The returned JSON is the same format as listed for the full-resolution details endpoint.
- `DELETE /image/delete/{delete_token}/{file}` or `GET /image/delete/{delete_token}/{file}` to
    delete a file, where `delete_token` and `file` are from the `/image` endpoint's JSON

## Missing {#module-services-pict-rs-missing}

- Configuring the secure-api-key is not included yet. The envisioned basic use case is consumption on localhost by other services without exposing the service to the internet.
