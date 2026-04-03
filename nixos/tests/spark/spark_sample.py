from pyspark.sql import Row, SparkSession
from pyspark.sql import functions as F
from pyspark.sql.functions import udf
from pyspark.sql.types import *
from pyspark.sql.functions import explode

def explode_col(weight):
    return int(weight//10) * [10.0] + ([] if weight%10==0 else [weight%10])

spark = SparkSession.builder.getOrCreate()

dataSchema = [
    StructField("feature_1", FloatType()),
    StructField("feature_2", FloatType()),
    StructField("bias_weight", FloatType())
]

data = [
    Row(0.1, 0.2, 10.32),
    Row(0.32, 1.43, 12.8),
    Row(1.28, 1.12, 0.23)
]

df = spark.createDataFrame(spark.sparkContext.parallelize(data), StructType(dataSchema))

normalizing_constant = 100
sum_bias_weight = df.select(F.sum('bias_weight')).collect()[0][0]
normalizing_factor = normalizing_constant / sum_bias_weight
df = df.withColumn('normalized_bias_weight', df.bias_weight * normalizing_factor)
df = df.drop('bias_weight')
df = df.withColumnRenamed('normalized_bias_weight', 'bias_weight')

my_udf = udf(lambda x: explode_col(x), ArrayType(FloatType()))
df1 = df.withColumn('explode_val', my_udf(df.bias_weight))
df1 = df1.withColumn("explode_val_1", explode(df1.explode_val)).drop("explode_val")
df1 = df1.drop('bias_weight').withColumnRenamed('explode_val_1', 'bias_weight')

df1.show()

assert(df1.count() == 12)
