from setuptools import setup

setup(
    name='@pname@',
    version='@version@',
    install_requires=[
        "pyyaml",
        "dnspython",
        "lxml",
        "mechanize",
        "requests",
        "flask",
        "flask-restful",
        "flasgger",
        "dicttoxml",
        "xlsxwriter",
        "unicodecsv",
        "rq"
    ],
    scripts=[
        'recon-ng',
        "recon-cli",
        "recon-web"
    ],
)
